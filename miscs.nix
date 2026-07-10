{
  time.timeZone = "Asia/Shanghai";
  networking.networkmanager = {
    enable = true;
    dns = "none";
  };
  networking.nameservers = [
    "223.5.5.5"
    "1.1.1.1"
    "8.8.8.8"
  ];
}
