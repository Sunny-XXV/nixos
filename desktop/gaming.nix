{pkgs, ...}: {
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];

  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = false;
}
