RUNTIME_DIR="${ASR_RUNTIME_DIR:-/tmp/asr-ptt}"
FIFO_PATH="${RUNTIME_DIR}/control.fifo"
LOG_FILE="${RUNTIME_DIR}/ptt.log"
SERVER_URL="${ASR_SERVER_URL:-http://127.0.0.1:9931/v1/audio/transcriptions}"
HOTWORDS_FILE="${ASR_HOTWORDS_FILE:-}"
ESPANSO_BIN="${ASR_ESPANSO_BIN:-/Applications/Espanso.app/Contents/MacOS/espanso}"

mkdir -p "$RUNTIME_DIR"
chmod 700 "$RUNTIME_DIR"

log() {
  printf '%s %s\n' "$(date -Iseconds)" "$*" >> "$LOG_FILE"
  if [[ -f "$LOG_FILE" ]] && (( $(stat -c %s "$LOG_FILE" 2>/dev/null || echo 0) > 102400 )); then
    tail -n 200 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv -f "${LOG_FILE}.tmp" "$LOG_FILE" || true
  fi
}

stop_recorder() {
  local pid="$1"
  [[ -n "$pid" ]] || return 0

  if kill -0 "$pid" 2>/dev/null; then
    kill -INT "$pid" 2>/dev/null || true
    for _ in {1..20}; do
      kill -0 "$pid" 2>/dev/null || break
      sleep 0.02
    done
  fi

  if kill -0 "$pid" 2>/dev/null; then
    kill -TERM "$pid" 2>/dev/null || true
    sleep 0.05
    kill -KILL "$pid" 2>/dev/null || true
  fi

  wait "$pid" 2>/dev/null || true
}

build_hotword_prompt() {
  [[ -n "$HOTWORDS_FILE" && -r "$HOTWORDS_FILE" ]] || return 0
  local terms
  terms="$(awk '{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if ($0 != "" && $0 !~ /^#/) printf "%s%s", (n++ ? "、" : ""), $0}' "$HOTWORDS_FILE")"
  if [[ -n "$terms" ]]; then
    printf '请准确转写音频。以下是可能出现的专有词汇，请按这些拼写转写：%s。' "$terms"
  fi
}

transcribe_and_paste() {
  local wav="$1"
  trap - INT TERM
  trap 'rm -f "$wav"' EXIT

  [[ -n "$wav" && -s "$wav" ]] || return 0

  local stats duration rms
  stats="$(sox "$wav" -n stat 2>&1 || true)"
  duration="$(printf '%s\n' "$stats" | awk '/Length \(seconds\):/ {print $3; exit}')"
  rms="$(printf '%s\n' "$stats" | awk '/RMS[[:space:]]+amplitude:/ {print $3; exit}')"

  if [[ -z "$duration" || -z "$rms" || "$rms" == "nan" ]]; then
    log "dropped: invalid audio stats"
    return 0
  fi

  if awk "BEGIN {exit !($duration < 0.35)}"; then
    log "dropped: short tap (${duration}s)"
    return 0
  fi

  if awk "BEGIN {exit !($rms < 0.0020)}"; then
    log "dropped: silence (duration=${duration}s rms=${rms})"
    return 0
  fi

  local max_tokens prompt response text
  max_tokens="$(awk "BEGIN {t = int($duration * 8) + 64; printf \"%d\", (t > 512 ? 512 : t)}")"
  prompt="$(build_hotword_prompt)"

  local -a curl_args=(
    -sS --fail-with-body
    --connect-timeout 2
    --max-time 30
    -F "file=@$wav;type=audio/wav"
    -F "response_format=json"
    -F "max_tokens=$max_tokens"
  )
  if [[ -n "$prompt" ]]; then
    curl_args+=(-F "prompt=$prompt")
  fi

  if ! response="$(/usr/bin/curl "${curl_args[@]}" "$SERVER_URL" 2>&1)"; then
    log "transcription error: $response"
    return 1
  fi

  if ! text="$(printf '%s' "$response" \
    | jq -r '(.text // "") | sub("^[[:space:]]*[lL]anguage[[:space:]]+[^<]*<asr_text>[[:space:]]*"; "") | sub("</asr_text>[[:space:]]*$"; "") | gsub("^[[:space:]]+|[[:space:]]+$"; "")' 2>/dev/null)"; then
    log "invalid json response: $response"
    return 1
  fi

  if [[ -z "$text" ]]; then
    log "empty transcript (duration=${duration}s rms=${rms})"
    return 0
  fi

  printf '%s' "$text" | /usr/bin/pbcopy
  if [[ -x "$ESPANSO_BIN" ]]; then
    local esp_err
    if ! esp_err="$("$ESPANSO_BIN" match exec --trigger ":__asr_paste__" 2>&1)"; then
      log "espanso paste error: $esp_err"
      return 1
    fi
  fi
  log "ok: duration=${duration}s rms=${rms} chars=${#text}"
}

rm -f "$FIFO_PATH"
mkfifo -m 600 "$FIFO_PATH"
exec 3<> "$FIFO_PATH"

rec_pid=""
current_wav=""

cleanup() {
  stop_recorder "$rec_pid"
  rm -f "$FIFO_PATH" "$current_wav"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

log "asr-ptt daemon ready (pid=$$) on $FIFO_PATH"

while IFS= read -r cmd <&3; do
  case "$cmd" in
    start)
      if [[ -n "$rec_pid" ]]; then
        kill -0 "$rec_pid" 2>/dev/null && continue
        wait "$rec_pid" 2>/dev/null || true
        rm -f "$current_wav"
      fi
      current_wav="$(mktemp "${RUNTIME_DIR}/capture.XXXXXX.wav")"
      rec -q -V1 --buffer 1024 -c 1 -b 16 -e signed-integer -t wav "$current_wav" rate 16k trim 0 120 &
      rec_pid=$!
      log "recording started pid=$rec_pid"
      ;;
    stop)
      [[ -n "$rec_pid" ]] || continue
      stop_recorder "$rec_pid"
      rec_pid=""
      transcribe_and_paste "$current_wav" &
      current_wav=""
      ;;
  esac
done
