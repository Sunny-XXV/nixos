{pkgs, ...}: {
  programs.fish.completions = {
    podman.body = ''
      ${pkgs.podman}/bin/podman completion fish | source
    '';
  };
}
