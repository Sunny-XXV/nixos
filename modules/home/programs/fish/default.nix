{pkgs, ...}: {
  imports = [
    ./aliases.nix
    ./completions.nix
    ./functions.nix
    ./interactive.nix
    ./plugins.nix
    ./make-default.nix
  ];

  programs.fish.enable = true;
}
