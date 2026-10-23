{pkgs, ...}: let
  betterdisplay = pkgs.symlinkJoin {
    name = "betterdisplay-with-cli-${pkgs.betterdisplay.version}";
    paths = [pkgs.betterdisplay];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      mkdir -p "$out/bin"
      makeWrapper \
        "$out/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay" \
        "$out/bin/betterdisplaycli"
    '';
  };
in {
  environment.systemPackages = with pkgs; [
    aldente
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
