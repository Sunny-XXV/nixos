{pkgs, ...}: {
  programs.nixvim.plugins = {
    gitsigns.enable = true;
    indent-blankline.enable = true;
    lualine.enable = true;
    nvim-tree.enable = true;
    which-key.enable = true;

    mini.enable = true;
    mini.modules = {
      ai = {
        n_lines = 50;
        search_method = "cover_or_next";
      };
      comment = {
        mappings = {
          comment = "<leader>/";
          comment_line = "<leader>/";
          comment_visual = "<leader>/";
          textobject = "<leader>/";
        };
      };
      diff = {
        view = {
          style = "sign";
        };
      };
      starter = {
        content_hooks = {
          "__unkeyed-1.adding_bullet" = {
            __raw = "require('mini.starter').gen_hook.adding_bullet()";
          };
          "__unkeyed-2.indexing" = {
            __raw = "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
          };
          "__unkeyed-3.padding" = {
            __raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
          };
        };
        evaluate_single = true;
        header = ''
          ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
          ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
          ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
          ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
          ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
        '';
        items = {
          "__unkeyed-1.buildtin_actions" = {
            __raw = "require('mini.starter').sections.builtin_actions()";
          };
          "__unkeyed-2.recent_files_current_directory" = {
            __raw = "require('mini.starter').sections.recent_files(3, false)";
          };
          "__unkeyed-3.recent_files" = {
            __raw = "require('mini.starter').sections.recent_files(3, true)";
          };
          # "__unkeyed-4.sessions" = {
          #   __raw = "require('mini.starter').sections.sessions(5, true)";
          # };
        };
      };
      surround = {
        mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };
      };
    };
    mini-icons = {
      enable = true;
      mockDevIcons = true;
    };

    telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };
  };
}
