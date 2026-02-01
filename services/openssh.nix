{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
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

  systemd.services.sshd.serviceConfig = {
    CPUWeight = 1000;
    IOWeight = 1000;
    MemoryMin = "50M";
    OOMScoreAdjust = -1000;
  };
}
