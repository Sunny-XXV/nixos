{
  networking.firewall.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };
}
