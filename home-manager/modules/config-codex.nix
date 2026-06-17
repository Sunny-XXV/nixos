{config, ...}: let
  hmRoot = "${config.home.homeDirectory}/.config/nixos/home-manager";
in {
  programs.codex.enable = true;
  home.file.".codex/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${hmRoot}/dotfiles/codex/config.toml";
}
