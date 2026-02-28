{pkgs, ...}: {
  networking.hostName = "Syy-Mac";

  time.timeZone = "Asia/Shanghai";

  # nix configuration (macOS-compatible)
  nix.package = pkgs.lixPackageSets.stable.lix;
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "sunya"];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };

  # macOS system preferences
  system.defaults = {
    dock.autohide = true;
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  users.users.sunya = {
    name = "sunya";
    home = "/Users/sunya";
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

  system.stateVersion = 6;
}
