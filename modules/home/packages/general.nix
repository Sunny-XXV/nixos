{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    cloc
    coreutils
    fd
    gnused
    jq
    lazygit
    less
    libqalculate
    lsof
    mosh
    ncdu
    nil
    procs
    ripgrep
    rsync
    watch
  ];
}
