{pkgs, ...}: {
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.dedicatedServer.openFirewall = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];

  hardware.steam-hardware.enable = true;

  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = false;
}
