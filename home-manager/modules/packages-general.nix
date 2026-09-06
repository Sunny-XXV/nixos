{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
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
      nil
      procs
      rsync
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      gurobi
      mailutils
      netcat
      powertop
      sshpass
      strace
      usbutils
    ];
}
