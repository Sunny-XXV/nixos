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
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
  };
}
