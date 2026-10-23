{
  hostPlatform,
  lib,
  pkgs,
  username,
  ...
}: let
  isDarwin = lib.hasSuffix "-darwin" hostPlatform;
  isLinux = lib.hasSuffix "-linux" hostPlatform;
in
  lib.mkMerge [
    {
      # nixpkgs currently passes -Dmimalloc to Lix 2.95, whose Meson project does
      # not define that option. Keep one shared workaround until Lix 2.96.
      nix.package = pkgs.lixPackageSets.stable.lix.overrideAttrs (old: {
        mesonFlags =
          if lib.versionOlder old.version "2.96"
          then builtins.filter (flag: !lib.hasPrefix "-Dmimalloc=" flag) old.mesonFlags
          else old.mesonFlags;
      });

      nix = {
        channel.enable = false;

        settings = {
          trusted-users = ["root" username];
          experimental-features = ["nix-command" "flakes"];
          extra-deprecated-features = ["broken-string-escape" "or-as-identifier"];

          substituters = [
            "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://cache.nixos.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
          extra-substituters = ["https://cache.lix.systems"];
          extra-trusted-public-keys = [
            "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
          ];

          connect-timeout = 5;
          fallback = true;
        };
      };

      nix.optimise.automatic = true;
      nix.gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };

      nixpkgs.config.allowUnfree = true;
    }

    (lib.optionalAttrs isLinux {
      nix.gc.dates = "weekly";
      programs.nix-ld.enable = true;
    })

    (lib.optionalAttrs isDarwin {
      nix.optimise.interval = {
        Hour = 3;
        Minute = 45;
      };
    })
  ]
