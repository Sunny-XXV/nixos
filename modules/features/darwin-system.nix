{inputs, ...}: {
  flake.modules.darwin.syy-mac = {pkgs, ...}: {
    nix = {
      package = pkgs.lixPackageSets.stable.lix;
      channel.enable = false;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        trusted-users = ["root" "sunya"];
        extra-substituters = ["https://cache.lix.systems"];
        extra-trusted-public-keys = [
          "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        ];
      };
    };

    nixpkgs = {
      hostPlatform = "aarch64-darwin";
      config.allowUnfree = true;
    };

    system = {
      primaryUser = "sunya";
      stateVersion = 6;
      configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      # Office upgrades are opt-in. This complements the non-greedy Homebrew
      # cask declarations by disabling Microsoft AutoUpdate's background
      # installation; `msupdate` or `brew upgrade --cask --greedy ...` can
      # still be run explicitly.
      defaults.CustomUserPreferences."com.microsoft.autoupdate2".HowToCheck = "Manual";
    };

    users.users.sunya.home = "/Users/sunya";

    programs.zsh.enable = true;
    programs.fish.enable = true;

    # Kept intentionally small: interactive tools belong to Home Manager.
    environment.systemPackages = [pkgs.alejandra];
    environment.systemPath = [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];
  };
}
