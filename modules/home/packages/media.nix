{pkgs, ...}: {
  home.packages = with pkgs; [
    p7zip
    ffmpeg
    ffmpegthumbnailer
    pandoc
    pdftk
    poppler
    yt-dlp
  ];
}
