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
    lsof
    mailutils
    netcat
    nil
    powertop
    rsync
    sshpass
    strace
    usbutils
  ];
}
