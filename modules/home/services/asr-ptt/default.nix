{
  config,
  lib,
  pkgs,
  ...
}: let
  runtimeDir = "/tmp/asr-ptt";
  logFile = "${runtimeDir}/ptt.log";
  hotwordsFile = "${config.home.homeDirectory}/.config/nixos/modules/home/services/asr/hotwords.txt";

  asrPttDaemon = pkgs.writeShellApplication {
    name = "asr-ptt-daemon";
    runtimeInputs = with pkgs; [sox jq coreutils gnused gawk];
    text = builtins.readFile ./ptt-daemon.sh;
  };

  asrPttCli = pkgs.writeShellApplication {
    name = "asr-ptt";
    runtimeInputs = [pkgs.coreutils];
    text = builtins.readFile ./asr-ptt.sh;
  };
in {
  home.packages = [pkgs.sox asrPttCli];

  launchd.agents.asr-ptt = {
    enable = true;
    config = {
      Label = "org.nix-community.home.asr-ptt";
      ProgramArguments = [(lib.getExe asrPttDaemon)];
      EnvironmentVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        ASR_RUNTIME_DIR = runtimeDir;
        ASR_HOTWORDS_FILE = hotwordsFile;
        ASR_SERVER_URL = "http://127.0.0.1:9931/v1/audio/transcriptions";
      };
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
      LimitLoadToSessionType = "Aqua";
      ThrottleInterval = 2;
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
    };
  };
}
