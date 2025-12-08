{
  programs.tealdeer.enable = true;
  programs.tealdeer.enableAutoUpdates = true;
  programs.tealdeer.settings = {
    updates = {
      auto_update = true;
      auto_update_interval_hours = 72;
    };
    display = {
      use_pager = true;
    };
  };
}
