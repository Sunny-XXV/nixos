{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  logFile = "${homeDir}/Library/Logs/rex-server.log";
  rexServerDarwin = pkgs.writeShellScript "rex-server-darwin" ''
    set -euo pipefail
    trap 'exit 0' TERM INT

    socket="/var/run/tailscaled.socket"
    tailscale="${pkgs.tailscale}/bin/tailscale"

    while [ ! -S "$socket" ] || ! "$tailscale" --socket "$socket" ip -4 >/dev/null 2>&1; do
      ${pkgs.coreutils}/bin/sleep 1
    done

    exec "${homeDir}/.local/bin/rex" server run \
      --extra-listen tailnet://:7297 \
      --tailscaled-socket "$socket" \
      --log-format text
  '';
in
{
  imports = [
    inputs.rex.homeManagerModules.default
  ];

  programs.rex.enable = true;

  services.rex = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    extraListen = [ "tailnet://:7297" ];
  };

  launchd.agents.rex = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      Label = "org.nix-community.home.rex";
      ProgramArguments = [
        "${rexServerDarwin}"
      ];
      EnvironmentVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        TERMINFO_DIRS = "${homeDir}/.terminfo:";
      };
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
      LimitLoadToSessionType = "Aqua";
      ThrottleInterval = 5;
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
    };
  };
}
