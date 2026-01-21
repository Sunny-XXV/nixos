{
  config,
  pkgs,
  ...
}: {
  users.users.sunya = {
    isNormalUser = true;
    description = "sunya";
    extraGroups = ["networkmanager" "wheel" "podman" "audio" "video" "input" "uinput"];
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
