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
    sslCertificate = "/var/lib/tailscale/certs/syy-pc.taile2b66b.ts.net.crt";
    sslCertificateKey = "/var/lib/tailscale/certs/syy-pc.taile2b66b.ts.net.key";

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
}
