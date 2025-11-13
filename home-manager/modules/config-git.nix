{...}: {
  programs.git = {
    enable = true;

    ignores = [
      # macOS
      ".DS_Store"
      # Python
      "__pycache__/"
      "*.pyc"
      ".venv/"
      # Node.js
      "node_modules/"
      # Editor/IDE
      ".vscode/"
      ".idea/"
    ];

    settings = {
      user = {
        name = "sunya";
        email = "ydsunyan123@gmail.com";
      };

      help.autocorrect = 1;
      color.ui = true;
      pull.rebase = true;
      # commit.gpgsign = true;

      core = {
        whitespace = "trailing-space,space-before-tab";
        pager = "delta";
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      merge = {
        conflictStyle = "zdiff3";
      };
    };

    signing = {
      # for GPG key
      # key = "694FD0DC9528E0B9";
      # signByDefault = true;

      # for SSH key
      # key = "~/.ssh/id_ed25519.pub";
      # signByDefault = true;
    };
  };
}
