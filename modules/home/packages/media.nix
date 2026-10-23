{pkgs, ...}: {
  home.packages = with pkgs; [
    p7zip
    ffmpeg
    ffmpegthumbnailer
    pandoc
    poppler
    yt-dlp
  ];
}
