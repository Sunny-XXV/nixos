{
  programs.btop = {
    enable = true;
    settings = {
      shown_boxes = "proc cpu mem net gpu0";
      theme_background = false;
      truecolor = true;
      update_ms = 1000;
      vim_keys = true;
    };
  };
}
