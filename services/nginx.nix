{
  config,
  pkgs,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
  };
}
