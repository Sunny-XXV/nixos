{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    android-tools
    betterdisplay
    ghostty-bin
    iina
    iterm2
    scrcpy
    sioyek
  ];
}
