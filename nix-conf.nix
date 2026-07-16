{pkgs, ...}: {
  nix.package = pkgs.lixPackageSets.stable.lix;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["root" "sunya"];

  nix.settings.extra-deprecated-features = ["broken-string-escape" "or-as-identifier"];

  nix.settings.auto-optimise-store = true;

  nix.settings.substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.connect-timeout = 5;
  nix.settings.fallback = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  programs.nix-ld.enable = true;
}
