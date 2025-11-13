{...}: {
  programs.btop = {
    enable = true;
    extraConfig = ''
      theme_background = False
      truecolor = True
      vim_keys = True
      update_ms = 1000
    '';
  };
}
