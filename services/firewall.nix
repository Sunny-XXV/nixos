{
  networking.firewall.enable = true;
  networking.firewall = {
    allowedTCPPorts = [
      22
      24247
      80
      443
    ];
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };
}
