{
  imports = [
    ./config-foot.nix
  ];

  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;
}
