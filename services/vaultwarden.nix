{
  config,
  pkgs,
  lib,
  ...
}: {
  services.vaultwarden = {
    enable = true;
    config = {
      DATA_FOLDER = "/var/lib/vaultwarden";
      DOMAIN = "https://syy-pc.taile2b66b.ts.net:8454";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8455;
    };
    webVaultPackage = pkgs.vaultwarden.webvault;
  };

  services.nginx.virtualHosts."syy-pc.taile2b66b.ts.net" = {
    http2 = true;
    listen = [
      {
        addr = "0.0.0.0";
        port = 8454;
        ssl = true;
      }
      {
        addr = "[::]";
        port = 8454;
        ssl = true;
      }
    ];

    forceSSL = true;
    sslCertificate = "/etc/nginx/tailscale-certs/syy-pc.taile2b66b.ts.net.crt";
    sslCertificateKey = "/etc/nginx/tailscale-certs/syy-pc.taile2b66b.ts.net.key";

    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        recommendedProxySettings = true;
      };

      "/notifications/hub" = {
        proxyPass = "http://127.0.0.1:8455";
        proxyWebsockets = true;
      };
    };
  };

  systemd.services.nginx-tailscale-cert-sync = {
    description = "Copy Tailscale certs for nginx";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.mkForce "${pkgs.coreutils}/bin/install -D -m 0640 -o root -g nginx /var/lib/tailscale/certs/syy-pc.taile2b66b.ts.net.crt /etc/nginx/tailscale-certs/syy-pc.taile2b66b.ts.net.crt";
      ExecStartPost = "${pkgs.coreutils}/bin/install -D -m 0640 -o root -g nginx /var/lib/tailscale/certs/syy-pc.taile2b66b.ts.net.key /etc/nginx/tailscale-certs/syy-pc.taile2b66b.ts.net.key";
    };
    after = ["tailscaled.service"];
    wantedBy = ["multi-user.target"];
  };

  systemd.paths.nginx-tailscale-cert-sync = {
    description = "Watch for Tailscale cert updates";
    pathConfig = {
      PathChanged = ["/var/lib/tailscale/certs"];
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.nginx.after = ["nginx-tailscale-cert-sync.service"];
}
