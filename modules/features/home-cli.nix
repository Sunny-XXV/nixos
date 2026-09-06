{...}: {
  # Cross-platform user tools. Keeping these in Home Manager gives Linux and
  # macOS the same shell/editor experience without populating the system profile.
  flake.modules.homeManager.cli = {
    imports = [
      ../../home-manager/modules/config-btop.nix
      ../../home-manager/modules/config-direnv.nix
      ../../home-manager/modules/config-eza.nix
      ../../home-manager/modules/config-fastfetch.nix
      ../../home-manager/modules/config-fonts.nix
      ../../home-manager/modules/config-fzf.nix
      ../../home-manager/modules/config-git.nix
      ../../home-manager/modules/config-man.nix
      ../../home-manager/modules/config-nvim
      ../../home-manager/modules/config-skills.nix
      ../../home-manager/modules/config-tmux.nix
      ../../home-manager/modules/config-yazi.nix
      ../../home-manager/modules/config-zoxide.nix
      ../../home-manager/modules/packages-general.nix
      ../../home-manager/modules/packages-media.nix
    ];
  };
}
