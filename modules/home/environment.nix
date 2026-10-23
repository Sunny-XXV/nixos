{
  programs = {
    bash.enable = true;
    home-manager.enable = true;
  };

  home = {
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      UV_NO_SYNC = "1";
      UV_PYTHON_DOWNLOADS = "never";
    };
  };

  news.display = "silent";
}
