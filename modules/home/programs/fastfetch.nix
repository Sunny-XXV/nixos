{ lib, pkgs, ... }:
let
  pokegetCompact = pkgs.writeShellApplication {
    name = "pokeget-compact";
    runtimeInputs = [ pkgs.pokeget-rs ];
    text = ''
      max_lines=15
      best=""
      best_lines=999
      for _ in 1 2 3 4 5 6 7 8; do
        out=$(pokeget random --hide-name)
        lines=0
        while IFS= read -r _; do
          lines=$((lines + 1))
        done <<< "$out"
        if [ "$lines" -le "$max_lines" ]; then
          printf '%s\n' "$out"
          exit 0
        fi
        if [ "$lines" -lt "$best_lines" ]; then
          best="$out"
          best_lines="$lines"
        fi
      done
      printf '%s\n' "$best"
    '';
  };
in
{
  home.packages = [ pkgs.pokeget-rs ];

  programs.fastfetch = {
    enable = true;
    settings = {
      display.duration.abbreviation = true;
      logo = {
        type = "command-raw";
        source = lib.getExe pokegetCompact;
        padding = {
          left = 2;
          right = 2;
          top = 1;
        };
      };
      modules = [
        "title"
        "separator"
        "datetime"
        "os"
        "host"
        "kernel"
        "uptime"
        "shell"
        {
          "type" = "display";
          "format" = "{width}x{height}{?scale-factor} @ {refresh-rate} Hz";
        }
        {
          "type" = "cpu";
          "showPeCoreCount" = true;
          "temp" = true;
        }
        {
          "type" = "gpu";
          "driverSpecific" = true;
          "temp" = true;
        }
        "memory"
        {
          "type" = "disk";
          "format" = "{size-used} / {size-total} ({size-percentage}) - {filesystem}";
        }
        {
          "type" = "battery";
          "key" = "Battery";
          "format" = "{capacity}{?time-formatted} ({time-formatted} left){?}{?status} [{status}]{?}";
        }
        {
          "type" = "localip";
        }
        "locale"
        "break"
        "colors"
      ];
    };
  };
}
