{pkgs, ...}: {
  gtk.enable = true;

  gtk.font = {
    name = "Sarasa UI SC";
    size = 11;
  };

  gtk.theme = {
    name = "Colloid-Purple-Dark-Compact-Nord";
    package = pkgs.colloid-gtk-theme.override {
      colorVariants = ["dark"];
      sizeVariants = ["compact"];
      themeVariants = ["purple"];
      tweaks = [
        "nord"
        "black"
        "float"
        "rimless"
      ];
    };
  };

  gtk.iconTheme = {
    name = "Colloid-dark";
    package = pkgs.colloid-icon-theme;
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
