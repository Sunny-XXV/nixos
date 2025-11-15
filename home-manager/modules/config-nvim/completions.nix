{
  programs.nixvim.plugins = {
    luasnip.enable = true;
    friendly-snippets.enable = true;
  };

  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    sources = [
      {name = "nvim_lsp";}
      {name = "luasnip";}
      {name = "path";}
      {name = "buffer";}
    ];
  };
}
