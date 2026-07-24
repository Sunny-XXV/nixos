{
  config,
  pkgs,
  ...
}: let
  hmRoot = "${config.home.homeDirectory}/.config/nixos/home-manager";
in {
  programs.claude-code.enable = false;
  programs.claude-code.package = pkgs.claude-code;
  home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${hmRoot}/dotfiles/claude/settings.json";
}
