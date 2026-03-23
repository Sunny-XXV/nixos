{pkgs, ...}: {
  programs.claude-code.enable = true;
  programs.claude-code.package = pkgs.claude-code-bin;
  programs.claude-code.settings = {
    env = {
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
      DISABLE_INSTALLATION_CHECKS = "1";
    };
    cleanupPeriodDays = 720;
    hooks = {
      PostToolUse = [
        {
          hooks = [
            {
              command = "nix fmt $(jq -r '.tool_input.file_path' <<< '$CLAUDE_TOOL_INPUT')";
              type = "command";
            }
          ];
          matcher = "Edit|MultiEdit|Write";
        }
      ];
      PreToolUse = [
        {
          hooks = [
            {
              command = "echo 'Running command: $CLAUDE_TOOL_INPUT'";
              type = "command";
            }
          ];
          matcher = "Bash";
        }
      ];
    };
    includeCoAuthoredBy = false;
    permissions = {
      allow = [
        "Bash(git diff:*)"
        "Edit"
      ];
      ask = [
        "Bash(git push:*)"
      ];
      defaultMode = "acceptEdits";
      deny = [
        "WebFetch"
        "Bash(curl:*)"
        "Read(./.env*)"
        "Read(./secrets/**)"
      ];
      disableBypassPermissionsMode = "disable";
    };
    statusLine = {
      command = ''
        #!/bin/bash
        set -f
        input=$(cat)
        if [ -z "$input" ]; then printf "Claude"; exit 0; fi

        blue='\033[38;2;0;153;255m' orange='\033[38;2;255;176;85m'
        green='\033[38;2;0;175;80m' cyan='\033[38;2;86;182;194m'
        red='\033[38;2;255;85;85m' yellow='\033[38;2;230;200;0m'
        white='\033[38;2;220;220;220m' dim='\033[2m' reset='\033[0m'
        sep=" ''${dim}|''${reset} "

        color_for_pct() {
          local p=$1
          if [ "$p" -ge 90 ]; then printf "$red"
          elif [ "$p" -ge 70 ]; then printf "$yellow"
          elif [ "$p" -ge 50 ]; then printf "$orange"
          else printf "$green"; fi
        }
        build_bar() {
          local p=$1 w=''${2:-15}
          [ "$p" -lt 0 ] 2>/dev/null && p=0; [ "$p" -gt 100 ] 2>/dev/null && p=100
          local f=$(( p * w / 100 )) e=$(( w - f )) c; c=$(color_for_pct "$p")
          local fs="" es=""
          for ((i=0;i<f;i++)); do fs+="="; done
          for ((i=0;i<e;i++)); do es+="-"; done
          printf "''${dim}[''${reset}''${c}''${fs}''${dim}''${es}''${reset}''${dim}]''${reset}"
        }
        fmt_tok() {
          local n=$1
          if [ "$n" -ge 1000000 ]; then awk "BEGIN {printf \"%.1fm\", $n/1000000}"
          elif [ "$n" -ge 1000 ]; then awk "BEGIN {printf \"%.0fk\", $n/1000}"
          else printf "%d" "$n"; fi
        }

        model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
        size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
        [ "$size" -eq 0 ] 2>/dev/null && size=200000
        it=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
        cc=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
        cr=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
        cur=$(( it + cc + cr ))
        pct=$(( size > 0 ? cur * 100 / size : 0 ))

        cwd=$(echo "$input" | jq -r '.cwd // ""')
        [ -z "$cwd" ] || [ "$cwd" = "null" ] && cwd=$(pwd)
        dn=$(basename "$cwd")
        gb=""; gd=""
        if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          gb=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
          [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ] && gd="*"
        fi

        sd=""
        ss=$(echo "$input" | jq -r '.session.start_time // empty')
        if [ -n "$ss" ] && [ "$ss" != "null" ]; then
          se=$(date -d "$ss" +%s 2>/dev/null)
          if [ -n "$se" ]; then
            el=$(( $(date +%s) - se ))
            if [ "$el" -ge 3600 ]; then sd="$(( el/3600 ))h$(( (el%3600)/60 ))m"
            elif [ "$el" -ge 60 ]; then sd="$(( el/60 ))m"
            else sd="''${el}s"; fi
          fi
        fi

        effort="default"
        [ -f "$HOME/.claude/settings.json" ] && effort=$(jq -r '.effortLevel // "default"' "$HOME/.claude/settings.json" 2>/dev/null)

        pc=$(color_for_pct "$pct")
        bar=$(build_bar "$pct" 15)
        out="''${blue}''${model}''${reset}"
        out+="''${sep}''${bar} ''${pc}''${pct}%''${reset} ''${dim}$(fmt_tok $cur)/$(fmt_tok $size)''${reset}"
        out+="''${sep}''${cyan}''${dn}''${reset}"
        [ -n "$gb" ] && out+=" ''${green}(''${gb}''${red}''${gd}''${green})''${reset}"
        [ -n "$sd" ] && out+="''${sep}''${white}''${sd}''${reset}"
        out+="''${sep}''${dim}''${effort}''${reset}"
        printf "%b" "$out"
      '';
      padding = 0;
      type = "command";
    };
    theme = "dark";
  };
}
