{
  config,
  pkgs,
  ...
}: {
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
}
