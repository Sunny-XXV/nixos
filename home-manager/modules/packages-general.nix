{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    cloc
    fastfetch
    fd
    jq
    lazygit
    ncdu
    ripgrep
    zoxide
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
