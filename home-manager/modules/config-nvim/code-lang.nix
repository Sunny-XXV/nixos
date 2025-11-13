{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight.enable = true;
    };
    folding = true;
    nixvimInjections = true;
  };

  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      ty.enable = true;
      nil_ls.enable = true;
    };
  };

  programs.nixvim.plugins.mason = {
    enable = true;
    ensureInstalled = {
      automaticInstallation = true;
    };
  };
}
