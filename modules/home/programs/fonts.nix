{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
  };
}
