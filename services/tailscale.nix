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
  renewalWindowSeconds = toString (30 * 24 * 60 * 60);
in {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    permitCertUid = nginxUser;
    useRoutingFeatures = "server";
  };

  services.tailscale.extraUpFlags = [
    "--ssh"
  ];
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
    description = "Ensure Tailscale certs exist and are fresh";
    after = ["tailscaled.service" "network-online.target"];
    wants = ["tailscaled.service" "network-online.target"];
    wantedBy = ["multi-user.target"];
    path = [pkgs.tailscale pkgs.acl pkgs.openssl pkgs.systemd pkgs.util-linux];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      TimeoutStartSec = "5min";
      ExecStart = pkgs.writeShellScript "generate-ts-cert" ''
        set -e
        CERT="${tsCertFile}"
        KEY="${tsKeyFile}"
        RENEW_BEFORE_SECONDS="${renewalWindowSeconds}"
        cert_updated=0

        if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
          echo "Certificates missing. Requesting new certificate..."
          needs_renew=1
        elif ! openssl x509 -checkend "$RENEW_BEFORE_SECONDS" -noout -in "$CERT"; then
          echo "Certificate expires within $RENEW_BEFORE_SECONDS seconds or is invalid. Renewing..."
          needs_renew=1
        else
          echo "Certificate is still valid for at least $RENEW_BEFORE_SECONDS seconds."
          needs_renew=0
        fi

        if [ "$needs_renew" -eq 1 ]; then
          ${pkgs.tailscale}/bin/tailscale cert \
            --cert-file "$CERT" \
            --key-file "$KEY" \
            "${tailnetDomain}"
          cert_updated=1
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

        if [ "$cert_updated" -eq 1 ] && systemctl is-active --quiet nginx.service; then
          echo "Reloading nginx to pick up renewed certificate..."
          systemctl --no-block reload nginx.service
        fi
      '';
    };
  };

  systemd.timers.tailscale-cert-generator = {
    description = "Refresh Tailscale certs";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
      Unit = "tailscale-cert-generator.service";
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
