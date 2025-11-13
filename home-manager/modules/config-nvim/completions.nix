{
  programs.nixvim.plugins = {
    luasnip.enable = true;
    friendly-snippets.enable = true;

    cmp = {
      enable = true;
      sources = [
        {name = "nvim_lsp";}
        {name = "luasnip";}
        {name = "bufer";}
        {name = "path";}
      ];
    };
  };
}
