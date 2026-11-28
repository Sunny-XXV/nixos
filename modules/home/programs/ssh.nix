{
  lib,
  meta,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  muxSettings = {
    ControlMaster = "auto";
    ControlPath = "~/.ssh/ctl-%C";
    ControlPersist = "10m";
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.local" ];

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      }
      // lib.optionalAttrs isDarwin {
        UseKeychain = "yes";
      };

      "${meta.hosts.pc} Syy-PC Syy-PC-TS" = muxSettings // {
        HostName = "${meta.hosts.pc}.${meta.tailnet}";
        User = meta.username;
      };

      "${meta.hosts.mac} Syy-Mac" = muxSettings // {
        HostName = "${meta.hosts.mac}.${meta.tailnet}";
        User = meta.username;
      };

      "github.com" = muxSettings // {
        AddKeysToAgent = "yes";
        HostName = "github.com";
        User = "git";
        IdentityFile = [ "~/.ssh/id_ed25519" ];
        IdentitiesOnly = true;
      };
    };
  };
}
