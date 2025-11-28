{
  config,
  lib,
  ...
}: {
  services.fail2ban.enable = true;
  services.fail2ban = {
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16";
      maxtime = "168h";
    };
  };

  services.fail2ban.ignoreIP = [
    "127.0.0.1/8"
    "10.0.0.0/8"
    "192.168.1.0/24"
    "100.64.0.0/10"
  ];

  services.fail2ban.jails = {};
}
