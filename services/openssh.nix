{
  lib,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;
      UsePAM = true;
      ClientAliveInterval = 60;
      ClientAliveCountMax = 5;
    };
    openFirewall = true;
    ports = [22 24247];
  };

  users.users.sunya = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJAJ0CBSOEo5ZSqEFcG1rQJk5QdxrbQcuIPcEczsLwH ydsunyan123@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpReUt3bToa+UM0TZx0aFGWBvWpFHBPb03sDsKDo7ab ydsunyan123@gmail.com"
    ];
  };

  # security.pam.services.sshd = {
  #   allowNullPassword = true;
  #   text = lib.mkForce ''
  #     auth [success=1 default=ignore] pam_succeed_if.so user != guest
  #     auth sufficient ${pkgs.oath-toolkit}/lib/security/pam_oath.so usersfile=/etc/security/users.oath window=30 digits=6
  #     auth include login
  #   '';
  # };

  systemd.services.sshd.serviceConfig = {
    CPUWeight = 1000;
    IOWeight = 1000;
    MemoryMin = "50M";
    OOMScoreAdjust = -1000;

    Restart = "always";
    RestartSec = "5s";
  };
}
