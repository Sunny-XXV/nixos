{
  pkgs,
  username,
  ...
}: let
  defaultMode = "2560x1600@60";

  setResolution = pkgs.writeShellApplication {
    name = "sunshine-set-resolution";
    runtimeInputs = with pkgs; [niri];
    text = ''
      w="''${SUNSHINE_CLIENT_WIDTH:-2560}"
      h="''${SUNSHINE_CLIENT_HEIGHT:-1600}"
      fps="''${SUNSHINE_CLIENT_FPS:-60}"
      niri msg output HDMI-A-1 mode "''${w}x''${h}@''${fps}" 2>/dev/null || \
        niri msg output HDMI-A-1 mode "''${w}x''${h}"
    '';
  };

  resetResolution = pkgs.writeShellApplication {
    name = "sunshine-reset-resolution";
    runtimeInputs = with pkgs; [niri];
    text = ''
      niri msg output HDMI-A-1 mode "${defaultMode}" 2>/dev/null || \
        niri msg output HDMI-A-1 mode "2560x1600"
    '';
  };

  niriDispatch = command:
    pkgs.writeShellScript "sunshine-niri-dispatch" ''
      exec ${pkgs.niri}/bin/niri msg action spawn-sh -- "${command}"
    '';

  steamBigPicture = niriDispatch "/run/current-system/sw/bin/steam steam://open/bigpicture";
  closeSteamBigPicture = niriDispatch "/run/current-system/sw/bin/steam -shutdown";
in {
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = username;
      command = "${pkgs.niri}/bin/niri-session";
    };
  };

  systemd.services.greetd = {
    startLimitIntervalSec = 60;
    startLimitBurst = 3;
    serviceConfig.RestartSec = "5s";
  };

  systemd.user.services.niri.enableDefaultPath = false;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      capture = "wlr";
      encoder = "nvenc";
      output_name = "HDMI-A-1";
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
