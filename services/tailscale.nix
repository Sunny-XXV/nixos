{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    permitCertUid = "nginx";
    useRoutingFeatures = "server";
  };

  services.tailscale.extraSetFlags = [
    "--relay-server-port=41232"
  ];
  networking.firewall.allowedUDPPorts = [41232];

  systemd.services.tailscaled.serviceConfig = {
    CPUWeight = 1000;
    IOWeight = 1000;
    MemoryMin = "100M";
    OOMScoreAdjust = -1000;

    Restart = "always";
    RestartSec = "5s";
  };
}
