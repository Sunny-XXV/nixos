{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./profile-default.nix
    ./profile-python.nix
  ];

  programs.vscode.enable = true;
  programs.vscode.profiles.default.enableExtensionUpdateCheck = false;
  programs.vscode.profiles.default.enableUpdateCheck = false;
}
