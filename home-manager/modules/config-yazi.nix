{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    enableFishIntegration = true;
    enableBashIntegration = true;

    settings = {
      mgr = {
        ratio = [1 4 3];
        sort_by = "alphabetical";
        sort_dir_first = true;
        sort_reverse = false;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
      };
      opener = {
        edit = [
          {
            run = "$EDITOR $@";
            block = true;
            for = "unix";
          }
        ];
      };
    };
  };
}
