{
  config,
  pkgs,
  ...
}: {
  users.users.sunya = {
    isNormalUser = true;
    description = "sunya";
    extraGroups = ["networkmanager" "wheel" "podman" "audio" "video" "input" "uinput" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJAJ0CBSOEo5ZSqEFcG1rQJk5QdxrbQcuIPcEczsLwH ydsunyan123@gmail.com"
    ];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    rsync
    alejandra
  ];

  environment.variables.EDITOR = "nvim";
}
