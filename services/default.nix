{
  imports = [
    ./nginx.nix
    ./fail2ban.nix
    ./firewall.nix
    ./openssh.nix
    ./proxy-dae.nix
    ./tailscale.nix
    ./vaultwarden.nix
    ./virtualisation.nix
  ];
}
