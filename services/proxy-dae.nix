{
  config,
  lib,
  pkgs,
  ...
}: let
  user = "sunya";
  daeConfigDir = "/var/lib/dae";
  daeSubPath = config.sops.secrets."dae/sub_nacho".path;
  daeConfigTemplate = pkgs.writeText "dae-config.dae.template" (builtins.readFile ../home-manager/dotfiles/dae/config.dae);
in {
  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
  sops.secrets."dae/sub_nacho" = {
    sopsFile = ./dae_secrets.yaml;
    key = "sub_nacho";
    owner = "root";
    group = "root";
    mode = "0400";
  };

  services.daed = {
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    configDir = daeConfigDir;
    listen = "127.0.0.1:2023";
  };

  systemd.services.daed = {
    preStart = lib.mkAfter ''
      if [ ! -r ${daeSubPath} ]; then
        echo "missing sops secret: ${daeSubPath}" >&2
        exit 1
      fi
      install -m 0600 ${daeConfigTemplate} ${daeConfigDir}/config.dae
      ${pkgs.perl}/bin/perl -0pi -e 'BEGIN { my $secret_file = shift @ARGV; open(my $fh, "<", $secret_file) or die "open $secret_file: $!"; chomp($secret = <$fh>); } s/\@DAE_SUB_NACHO\@/$secret/g' ${daeSubPath} ${daeConfigDir}/config.dae
    '';
  };
}
