{pkgs, ...}: {
  imports = [
    ./aliases.nix
    ./completions.nix
    ./functions.nix
    ./interactive.nix
    ./plugins.nix
  ];

  programs.fish.enable = true;
}
