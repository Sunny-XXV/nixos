{
  inputs,
  pkgs,
  ...
}: {
  programs.pi-coding-agent = {
    enable = true;
    package = inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
