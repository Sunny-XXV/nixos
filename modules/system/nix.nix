{ config, lib, meta, options, pkgs, ... }:
let
  isDarwin = options ? launchd;
  isLinux = options ? systemd;
in
{
  config = lib.mkMerge [
    {
      nix.package = pkgs.lixPackageSets.stable.lix;

      nix = {
        channel.enable = false;

        settings = {
          trusted-users = [ "root" meta.username ];
          experimental-features = [ "nix-command" "flakes" ];
          extra-deprecated-features = [ "broken-string-escape" "or-as-identifier" ];

          substituters = [
            # "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://cache.nixos.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
          extra-substituters = [ "https://cache.lix.systems" ];
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
        options = "--delete-older-than 3d";
      };

      nixpkgs.config.allowUnfree = true;

      sops.secrets."nix/github_pat" = {
        sopsFile = ./github-secrets.yaml;
        key = "github_pat";
      };

      sops.templates."nix-access-tokens.conf" = {
        content = ''
          access-tokens = github.com=${config.sops.placeholder."nix/github_pat"}
        '';
        owner = meta.username;
        mode = "0400";
      };

      # Use !include so nix.conf validation passes even before sops renders the secret
      nix.extraOptions = ''
        !include ${config.sops.templates."nix-access-tokens.conf".path}
      '';
    }

    (lib.optionalAttrs isLinux {
      nix.gc.dates = "weekly";
      programs.nix-ld.enable = true;
    })

    (lib.optionalAttrs isDarwin {
      nix.settings = {
        max-jobs = 2;
        cores = 2;
      };

      nix.optimise.interval = {
        Hour = 10;
        Minute = 45;
      };
    })
  ];
}
