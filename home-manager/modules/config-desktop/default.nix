{pkgs, ...}: {
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

  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;
}
