{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aldente
    android-tools
    betterdisplay
    dbeaver-bin
    ghostty-bin
    iina
    iterm2
    maccy
    moonlight-qt
    qbittorrent
    scrcpy
    sioyek
  ];
}
