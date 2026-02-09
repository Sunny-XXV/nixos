{
  config,
  pkgs,
  lib,
  ...
}: let
  tailnetDomain = "syy-pc.taile2b66b.ts.net";
  nginxUser = config.services.nginx.user;
  nginxGroup = config.services.nginx.group;

  tsDir = "/var/lib/tailscale";
  tsCertFile = "${tsDir}/certs/${tailnetDomain}.crt";
  tsKeyFile = "${tsDir}/certs/${tailnetDomain}.key";
in {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    permitCertUid = nginxUser;
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

  systemd.services.tailscale-cert-generator = {
    description = "Ensure Tailscale Certs Exist with Correct Permissions";
    after = ["tailscaled.service" "network-online.target"];
    wants = ["tailscaled.service" "network-online.target"];
    wantedBy = ["multi-user.target"];
    path = [pkgs.tailscale pkgs.acl pkgs.util-linux];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = pkgs.writeShellScript "generate-ts-cert" ''
        set -e
        CERT="${tsCertFile}"
        KEY="${tsKeyFile}"

        if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
          echo "Certificates missing. Requesting new execution..."
          ${pkgs.tailscale}/bin/tailscale cert \
            --cert-file "$CERT" \
            --key-file "$KEY" \
            "${tailnetDomain}"
        else
          echo "Certificates found. Checking permissions..."
        fi

        echo "Applying ACL for user ${nginxUser}..."
        setfacl -m m:rx,u:${nginxUser}:x "${tsDir}"
        setfacl -m m:rx,u:${nginxUser}:x "${tsDir}/certs"
        setfacl -m m:r,u:${nginxUser}:r "$CERT" "$KEY"

        if runuser -u ${nginxUser} -- test -r "$CERT"; then
          echo "Success: ${nginxUser} can read the certificate."
        else
          echo "Warning: ${nginxUser} still cannot read the certificate!"
          getfacl "${tsDir}"
          getfacl "${tsDir}/certs"
          getfacl "$CERT"
          exit 1
        fi
      '';
    };
  };

  # Grant Nginx with permission to Tailscale's cert
  systemd.tmpfiles.rules = [
    "A /var/lib/tailscale       - - - - u:${nginxUser}:x"
    "A /var/lib/tailscale/certs - - - - u:${nginxUser}:x"
  ];

  systemd.services.nginx.wants = ["tailscale-cert-generator.service"];
  systemd.services.nginx.after = ["tailscale-cert-generator.service"];
}
