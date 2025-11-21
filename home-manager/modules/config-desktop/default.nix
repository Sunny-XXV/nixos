{
  imports = [
    ./config-cursor.nix
    ./config-foot.nix
    ./config-xremap.nix
  ];

  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;
}
