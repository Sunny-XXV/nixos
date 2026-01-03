{pkgs, ...}: {
  home.packages = with pkgs; [
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
    mailutils
    netcat
    nil
    powertop
    procs
    rsync
    sshpass
    strace
    usbutils
  ];
}
