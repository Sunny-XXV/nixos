{pkgs, ...}: {
  home.packages = with pkgs; [
    p7zip
    ffmpeg
    pandoc
    pdftk
    poppler
    yt-dlp
  ];
}
