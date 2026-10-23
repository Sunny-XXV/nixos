{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight.enable = true;
    };
    folding.enable = true;
    nixvimInjections = true;
  };

  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    keymaps = {
      silent = true;
      diagnostic = {
        "[d" = "goto_prev";
        "]d" = "goto_next";
        "<leader>df" = "open_float";
        "<leader>dq" = "setloclist";
      };
      lspBuf = {
        "gd" = "definition";
        "gD" = "declaration";
        "gi" = "implementation";
        "gr" = "references";
        "K" = "hover";
        "<leader>D" = "type_definition";
        "<leader>ca" = "code_action";
        "<leader>rn" = "rename";
      };
    };
    servers = {
      ty = {
        enable = true;
        packageFallback = true;
      };
      ruff = {
        enable = true;
        packageFallback = true;
      };
      nil_ls = {
        enable = true;
        settings.formatting.command = ["alejandra"];
      };
    };
  };
}
