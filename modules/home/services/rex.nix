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
        "${homeDir}/.local/bin/rex"
        "server"
        "run"
        "--extra-listen"
        "tailnet://:7297"
        "--log-format"
        "text"
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
