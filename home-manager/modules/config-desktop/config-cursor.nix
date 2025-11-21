{ pkgs, ... }: {
  home.pointerCursor.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.apple-cursor;
    name = "macOS";
    size = 32;
  };
}
