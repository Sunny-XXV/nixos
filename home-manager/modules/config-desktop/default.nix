{
  imports = [
    ./config-cursor.nix
    ./config-foot.nix
    ./config-launcher.nix
    ./config-vscode
    ./config-xremap.nix
  ];

  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;

  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
