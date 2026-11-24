{ lib, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      shown_boxes = "proc cpu mem net gpu0";
      presets = lib.concatStringsSep " " [
        "cpu:1:default,proc:0:default"
        "cpu:0:default,mem:0:default,net:0:default"
        "cpu:0:block,net:0:tty"
        "cpu:0:default,gpu0:0:default,mem:0:default,net:0:default"
      ];
      theme_background = false;
      truecolor = true;
      update_ms = 1000;
      vim_keys = true;
    };
  };
}
