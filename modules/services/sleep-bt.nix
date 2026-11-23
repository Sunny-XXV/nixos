{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ blueutil ];
  homebrew.brews = [ "sleepwatcher" ];

  launchd.user.agents.sleep-bt = {
    serviceConfig = {
      ProgramArguments = [
        "${config.homebrew.prefix}/opt/sleepwatcher/sbin/sleepwatcher"
        "-V"
        "-s"
        "${pkgs.blueutil}/bin/blueutil -p 0"
        "-w"
        "${pkgs.blueutil}/bin/blueutil -p 1"
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
