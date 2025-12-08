{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/config-btop.nix
    ./modules/config-claudecode.nix
    ./modules/config-desktop
    ./modules/config-direnv.nix
    ./modules/config-eza.nix
    ./modules/config-fastfetch.nix
    ./modules/config-fish
    ./modules/config-fonts.nix
    ./modules/config-fzf.nix
    ./modules/config-gpg.nix
    ./modules/config-git.nix
    ./modules/config-man.nix
    ./modules/config-nvim
    ./modules/config-secrets
    ./modules/config-ssh.nix
    ./modules/config-tmux.nix
    ./modules/config-yazi.nix
    ./modules/packages-general.nix
    # ./modules/packages-gui.nix
    ./modules/packages-media.nix
    ./modules/packages-tex.nix
  ];

  programs.home-manager.enable = true;

  home.username = "sunya";
  home.homeDirectory = "/home/sunya";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Use fish as default shell
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  news.display = "silent";
}
