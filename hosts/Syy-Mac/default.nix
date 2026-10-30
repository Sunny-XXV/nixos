{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    inputs.sops-nix.darwinModules.sops

    ../../modules/system/nix.nix
    ../../modules/system/basic.nix
    ../../modules/desktop/homebrew.nix
    ../../modules/desktop/darwin-apps.nix
    ../../modules/desktop/fonts.nix
    ../../modules/services/llama.nix
    ../../modules/services/sleep-bt.nix
    ../../modules/services/mihomo.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    primaryUser = username;
    stateVersion = 6;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    defaults.CustomUserPreferences."com.microsoft.autoupdate2".HowToCheck = "Manual";
  };

  environment.shells = [pkgs.bashInteractive];
  programs.zsh.enable = false;

  users.users.${username}.home = "/Users/${username}";
  home-manager = {
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [
        ../../modules/home/environment.nix
        ../../modules/home/dotfiles
        ../../modules/home/packages/general.nix
        ../../modules/home/packages/media.nix
        ../../modules/home/programs/btop.nix
        ../../modules/home/programs/claudecode.nix
        ../../modules/home/programs/codex.nix
        ../../modules/home/programs/direnv.nix
        ../../modules/home/programs/eza.nix
        ../../modules/home/programs/fastfetch.nix
        ../../modules/home/programs/fish
        ../../modules/home/programs/fonts.nix
        ../../modules/home/programs/fzf.nix
        ../../modules/home/programs/git.nix
        ../../modules/home/programs/gpg.nix
        ../../modules/home/programs/ghostty.nix
        ../../modules/home/programs/man.nix
        ../../modules/home/programs/nvim
        ../../modules/home/programs/pi-agent.nix
        ../../modules/home/programs/skills.nix
        ../../modules/home/programs/ssh.nix
        ../../modules/home/programs/tmux.nix
        ../../modules/home/programs/vscodium.nix
        ../../modules/home/programs/yazi.nix
        ../../modules/home/programs/zed.nix
        ../../modules/home/programs/zoxide.nix
        ../../modules/home/desktop/karabiner.nix
        ../../modules/home/services/asr-ptt
        ../../modules/home/services/espanso.nix
      ];
    };
  };
}
