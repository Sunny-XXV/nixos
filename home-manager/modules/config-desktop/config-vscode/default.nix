{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ./profile-default.nix
    # ./profile-python.nix
  ];

  programs.vscodium.enable = true;
  programs.vscodium.profiles.default.enableExtensionUpdateCheck = false;
  programs.vscodium.profiles.default.enableUpdateCheck = false;
}
