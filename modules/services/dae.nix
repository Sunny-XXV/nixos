{
  config,
  pkgs,
  inputs,
  ...
}: let
  daePackage = inputs.daeuniverse.packages.${pkgs.system}.dae-release;
  daeConfigTemplate = builtins.readFile ../../dotfiles/dae/config.dae;
in {
  sops.secrets."dae/sub_nacho" = {
    sopsFile = ./dae-secrets.yaml;
    key = "sub_nacho";
    owner = "root";
    group = "root";
    mode = "0400";
  };

  sops.templates."dae-config.dae" = {
    content =
      builtins.replaceStrings
      ["@DAE_SUB_NACHO@"]
      [config.sops.placeholder."dae/sub_nacho"]
      daeConfigTemplate;
    owner = "root";
    mode = "0400";
    restartUnits = ["dae.service"];
  };

  services.dae = {
    enable = true;
    package = daePackage;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    configFile = config.sops.templates."dae-config.dae".path;
  };

  systemd.services.dae.serviceConfig = {
    MemoryHigh = "300M";
    MemoryMax = "1G";
  };
}
