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

  users.users.guest = {
    isNormalUser = true;
    hashedPassword = "!";
    extraGroups = ["networkmanager" "podman" "audio" "video" "input" "uinput"];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    rsync
    alejandra
    oath-toolkit
  ];

  environment.variables.EDITOR = "nvim";
}
