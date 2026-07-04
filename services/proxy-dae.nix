{
  services.daed = {
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    configDir = "/var/lib/dae";
    listen = "100.100.140.8:2023";
  };
}
