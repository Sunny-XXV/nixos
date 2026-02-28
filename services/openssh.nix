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
    extraConfig = ''
      Match Address 100.64.0.0/10
        PermitRootLogin prohibit-password
    '';
  };

  users.users.sunya = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJAJ0CBSOEo5ZSqEFcG1rQJk5QdxrbQcuIPcEczsLwH ydsunyan123@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpReUt3bToa+UM0TZx0aFGWBvWpFHBPb03sDsKDo7ab ydsunyan123@gmail.com"
    ];
  };

  users.users.root = {
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

    Restart = "always";
    RestartSec = "5s";
  };

  programs.mosh = {
    enable = true;
    openFirewall = true;
  };
}
