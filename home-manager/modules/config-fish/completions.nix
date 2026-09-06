{
  lib,
  pkgs,
  ...
}: {
  programs.fish.completions = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    podman.body = ''
      ${pkgs.podman}/bin/podman completion fish | source
    '';
  };
}
