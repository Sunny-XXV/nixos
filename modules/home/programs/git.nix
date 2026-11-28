{ config, meta, ... }:
{
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;

  programs.git = {
    enable = true;

    ignores = [
      "__pycache__/"
      "*.pyc"
      ".claude/"
      ".codex/"
      ".direnv/"
      ".DS_Store"
      ".idea/"
      ".venv/"
      ".vscode/"
      "node_modules/"
    ];

    settings = {
      user = {
        name = config.home.username;
        inherit (meta) email;
      };

      help.autocorrect = "prompt";
      color.ui = true;
      pull.rebase = true;
      init.defaultBranch = "master";

      core = {
        whitespace = "trailing-space,space-before-tab";
      };

      merge = {
        conflictStyle = "zdiff3";
      };
    };

    # signing = {
    #   format = "ssh";
    #   key = "~/.ssh/id_ed25519.pub";
    #   signByDefault = true;
    # };
  };
}
