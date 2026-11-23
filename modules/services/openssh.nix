{ meta, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      UsePAM = true;
      ClientAliveInterval = 60;
      ClientAliveCountMax = 5;
    };
    openFirewall = true;
    ports = [
      22
      24247
    ];
    extraConfig = ''
      Match Address 100.64.0.0/10
        PermitRootLogin prohibit-password
    '';
  };

  users.users.${meta.username} = {
    openssh.authorizedKeys.keys = meta.sshKeys;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = meta.sshKeys;
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
