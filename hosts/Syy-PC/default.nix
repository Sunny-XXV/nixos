{
  config,
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    ./hardware.nix

    ../../modules/system/nix.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/users.nix
    ../../modules/system/basic.nix
    ../../modules/system/boot.nix

    ../../modules/services/nginx.nix
    ../../modules/services/earlyoom.nix
    ../../modules/services/fail2ban.nix
    ../../modules/services/firewall.nix
    ../../modules/services/openssh.nix
    ../../modules/services/dae.nix
    ../../modules/services/rclone.nix
    ../../modules/services/remote-desktop.nix
    ../../modules/security/sops.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/vaultwarden.nix
    ../../modules/services/virtualisation.nix

    ../../modules/desktop/niri.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/gaming.nix
  ];

  networking.hostName = "Syy-PC";

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [
        ../../modules/home/environment.nix
        ../../modules/home/dotfiles
        ../../modules/home/packages/general.nix
        ../../modules/home/packages/media.nix
        ../../modules/home/packages/operation.nix
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
        ../../modules/home/programs/man.nix
        ../../modules/home/programs/nvim
        ../../modules/home/programs/skills.nix
        ../../modules/home/programs/ssh.nix
        ../../modules/home/programs/tmux.nix
        ../../modules/home/programs/vscodium.nix
        ../../modules/home/programs/yazi.nix
        ../../modules/home/programs/zoxide.nix
        ../../modules/home/desktop/clipboard.nix
        ../../modules/home/desktop/cursor.nix
        ../../modules/home/desktop/foot.nix
        ../../modules/home/desktop/launcher.nix
        ../../modules/home/desktop/niri.nix
        ../../modules/home/desktop/portals.nix
        ../../modules/home/desktop/theme.nix
        ../../modules/home/desktop/xremap.nix
        ../../modules/home/programs/gpg.nix
        ../../modules/home/programs/llama.nix
        ../../modules/home/programs/rbw.nix
      ];
    };
  };

  # for Nvidia GPU
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  # Use CUDA Binary Cache
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      # "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  nixpkgs.config.cudaSupport = true;

  # misc
  hardware.i2c.enable = true;
  hardware.uinput.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
