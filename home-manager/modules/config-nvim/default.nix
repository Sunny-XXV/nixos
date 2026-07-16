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
    enableMan = false;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    nixpkgs.source = pkgs.path;

    opts = {
      clipboard = "unnamedplus";
      foldlevel = 99;
      foldlevelstart = 99;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    extraConfigLua = ''
      if vim.env.SSH_TTY ~= nil or vim.env.SSH_CLIENT ~= nil then
        vim.g.clipboard = {
          name = 'OSC 52',
          copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
          },
          paste = {
            ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
            ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
          },
        }
      end
    '';
  };
}
