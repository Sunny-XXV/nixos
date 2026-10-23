{pkgs, ...}: {
  fonts.packages = with pkgs; [
    sarasa-gothic
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    serif = ["Noto Serif" "Noto Serif CJK SC"];
    sansSerif = ["Sarasa UI SC" "Noto Sans CJK SC"];
    monospace = ["JetBrains Mono Nerd Font" "Sarasa Mono SC"];
    emoji = ["Noto Color EMoji"];
  };
}
