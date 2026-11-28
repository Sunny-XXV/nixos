{
  config,
  lib,
  options,
  ...
}:
let
  isDarwin = options ? launchd;
  isLinux = options ? systemd;
in
{
  config = lib.mkMerge [
    {
      services.tailscale.enable = true;
    }

    (lib.optionalAttrs isLinux {
      services.tailscale = {
        openFirewall = true;
        permitCertUid = config.services.caddy.user;
        useRoutingFeatures = "server";
        relayServerPort = 41232;
        extraSetFlags = [
          "--accept-dns=false"
          "--ssh"
        ];
      };

      systemd.services.tailscaled.serviceConfig = {
        CPUWeight = 1000;
        IOWeight = 1000;
        MemoryMin = "100M";
        OOMScoreAdjust = -1000;

        Restart = "always";
        RestartSec = "5s";
      };
    })

    (lib.optionalAttrs isDarwin {
      launchd.daemons.tailscaled.serviceConfig.KeepAlive = true;
    })
  ];
}
