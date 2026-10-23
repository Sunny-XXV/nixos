{pkgs, ...}: {
  home.packages = with pkgs; [
    mailutils
    netcat
    powertop
    sshpass
    strace
    usbutils
  ];
}
