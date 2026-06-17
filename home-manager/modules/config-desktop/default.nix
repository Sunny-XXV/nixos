{config, ...}: let
  hmRoot = "${config.home.homeDirectory}/.config/nixos/home-manager";
in {
  imports = [
    ./config-cursor.nix
    ./config-foot.nix
    ./config-launcher.nix
    ./config-portal.nix
    ./config-theme.nix
    ./config-vscode
    ./config-xremap.nix
  ];

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${hmRoot}/dotfiles/niri/config.kdl";
}
