{
  pkgs,
  username,
  ...
}: let
  defaultMode = "2560x1600@60";
  hyprConf = pkgs.writeText "sunshine-hypr.conf" ''
    monitor=HEADLESS-SUNSHINE,${defaultMode},0x0,1
    workspace=1,monitor:HEADLESS-SUNSHINE,default:true

    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = NIXOS_OZONE_WL,1

    input {
      kb_layout = us
    }

    general {
      gaps_in = 0
      gaps_out = 0
      border_size = 0
    }

    decoration {
      rounding = 0
    }

    animations {
      enabled = false
    }
  '';

  sunshineHyprlandSession = pkgs.writeShellApplication {
    name = "sunshine-hyprland-session";
    runtimeInputs = with pkgs; [coreutils hyprland systemd];
    text = ''
      Hyprland -c ${hyprConf} &
      hypr_pid=$!
      trap 'kill "$hypr_pid" 2>/dev/null || true' INT TERM

      for _ in $(seq 1 200); do
        for candidate in "$XDG_RUNTIME_DIR"/hypr/*; do
          [ -S "$candidate/.socket.sock" ] || continue
          sig="$(basename "$candidate")"
          if HYPRLAND_INSTANCE_SIGNATURE="$sig" hyprctl monitors >/dev/null 2>&1; then
            export HYPRLAND_INSTANCE_SIGNATURE="$sig"
            break 2
          fi
        done
        kill -0 "$hypr_pid" 2>/dev/null || { wait "$hypr_pid"; exit $?; }
        sleep 0.1
      done

      hyprctl output create headless HEADLESS-SUNSHINE || true
      systemctl --user start sunshine.service || true

      wait "$hypr_pid"
    '';
  };

  setResolution = pkgs.writeShellApplication {
    name = "sunshine-set-resolution";
    runtimeInputs = with pkgs; [hyprland];
    text = ''
      w="''${SUNSHINE_CLIENT_WIDTH:-2560}"
      h="''${SUNSHINE_CLIENT_HEIGHT:-1600}"
      fps="''${SUNSHINE_CLIENT_FPS:-60}"
      hyprctl keyword monitor "HEADLESS-SUNSHINE,''${w}x''${h}@''${fps},0x0,1"
    '';
  };

  resetResolution = pkgs.writeShellApplication {
    name = "sunshine-reset-resolution";
    runtimeInputs = with pkgs; [hyprland];
    text = ''
      hyprctl keyword monitor "HEADLESS-SUNSHINE,${defaultMode},0x0,1"
    '';
  };

  hyprlandDispatch = command:
    pkgs.writeShellScript "sunshine-hyprland-dispatch" ''
      exec ${pkgs.hyprland}/bin/hyprctl dispatch exec "${command}"
    '';

  steamBigPicture = hyprlandDispatch "/run/current-system/sw/bin/steam steam://open/bigpicture";
  closeSteamBigPicture = hyprlandDispatch "/run/current-system/sw/bin/steam -shutdown";
in {
  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      user = username;
      command = "${sunshineHyprlandSession}/bin/sunshine-hyprland-session";
    };
  };

  systemd.services.greetd = {
    startLimitIntervalSec = 60;
    startLimitBurst = 3;
    serviceConfig.RestartSec = "5s";
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      capture = "wlr";
      encoder = "nvenc";
      output_name = "HEADLESS-SUNSHINE";
    };
    applications = {
      env = {
        PATH = "$(PATH):/run/current-system/sw/bin:/etc/profiles/per-user/${username}/bin";
      };
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
          prep-cmd = [
            {
              do = "${setResolution}/bin/sunshine-set-resolution";
              undo = "${resetResolution}/bin/sunshine-reset-resolution";
            }
          ];
        }
        {
          name = "Steam Big Picture";
          image-path = "steam.png";
          detached = [
            "${steamBigPicture}"
          ];
          prep-cmd = [
            {
              do = "${setResolution}/bin/sunshine-set-resolution";
              undo = "${resetResolution}/bin/sunshine-reset-resolution";
            }
            {
              do = "";
              undo = "${closeSteamBigPicture}";
            }
          ];
        }
      ];
    };
  };
}
