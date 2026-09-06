{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      p7zip
      ffmpeg
      pandoc
      poppler
      yt-dlp
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [pdftk];
}
