{
  pkgs,
  lib,
  ...
}: {
  home.packages =
    (with pkgs; [
      bat
      cloc
      fd
      jq
      lazygit
      ncdu
      ripgrep
      less
      libqalculate
      lsof
      netcat
      nil
      procs
      rsync
      sshpass
    ])
    ++ lib.optionals (!pkgs.stdenv.isDarwin) (with pkgs; [
      mailutils
      powertop
      strace
      usbutils
    ]);
}
