{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    cloc
    delta
    fastfetch
    fd
    fzf
    jq
    lazygit
    ncdu
    tldr
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
