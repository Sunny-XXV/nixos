{
  lib,
  options,
  pkgs,
  ...
}:
let
  isLinux = options ? systemd;
in
{
  config = {
    fonts = {
      packages = with pkgs; [
        sarasa-gothic
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
      ];
    }
    // lib.optionalAttrs isLinux {
      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [
            "Noto Serif"
            "Noto Serif CJK SC"
          ];
          sansSerif = [
            "Sarasa UI SC"
            "Noto Sans CJK SC"
          ];
          monospace = [
            "JetBrains Mono Nerd Font"
            "Sarasa Mono SC"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
