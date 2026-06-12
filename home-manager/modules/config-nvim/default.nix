{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./plugins.nix
    ./colorschemes.nix
    ./keymaps.nix
    ./code-lang.nix
    ./completions.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    nixpkgs.source = pkgs.path;

    opts = {
      foldlevel = 99;
      foldlevelstart = 99;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
  };
}
