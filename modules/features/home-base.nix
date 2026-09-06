{...}: {
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    programs.home-manager.enable = true;

    home = {
      username = "sunya";
      stateVersion = "25.05";
      sessionVariables = {
        EDITOR = "nvim";
        UV_NO_SYNC = "1";
        UV_PYTHON_DOWNLOADS = "never";
      };
    };

    news.display = "silent";

    assertions = [
      {
        assertion = lib.hasSuffix "/sunya" config.home.homeDirectory;
        message = "The sunya Home Manager profile must target sunya's home directory.";
      }
    ];
  };
}
