{
  config,
  pkgs,
  lib,
  ...
}: let
  daePkg = config.services.dae.package;
in {
  environment.systemPackages = [pkgs.daed];

  services.dae = {
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    configFile = "/var/lib/dae/config.dae";
  };

  systemd.services.dae = {
    serviceConfig = {
      DynamicUser = false;
      StateDirectory = "dae"; # => /var/lib/dae
      ReadWritePaths = ["/var/lib/dae"];
      WorkingDirectory = "/var/lib/dae";
      LoadCredential = lib.mkForce [];
      ExecStart = ["" "${daePkg}/bin/dae run --disable-timestamp -c /var/lib/dae/config.dae"];
      ExecStartPre = ["" "${daePkg}/bin/dae validate -c /var/lib/dae/config.dae"];
    };
  };
}
