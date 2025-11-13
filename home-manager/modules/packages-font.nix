{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    source-han-sans
  ];
}
