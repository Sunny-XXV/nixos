RUNTIME_DIR="${ASR_RUNTIME_DIR:-/tmp/asr-ptt}"
FIFO_PATH="${RUNTIME_DIR}/control.fifo"
LOG_FILE="${RUNTIME_DIR}/ptt.log"

cmd="${1:-status}"
case "$cmd" in
  start|stop)
    [[ -p "$FIFO_PATH" ]] && printf '%s\n' "$cmd" > "$FIFO_PATH" &
    ;;
  logs)
    tail -f "$LOG_FILE"
    ;;
  status)
    echo "=== ASR PTT Daemon ==="
    if [[ -p "$FIFO_PATH" ]]; then
      echo "Status: running (fifo=$FIFO_PATH)"
    else
      echo "Status: stopped"
    fi
    echo "=== Recent Logs ==="
    tail -n 20 "$LOG_FILE" 2>/dev/null || true
    ;;
  *)
    echo "Usage: asr-ptt {start|stop|status|logs}" >&2
    exit 1
    ;;
esac
