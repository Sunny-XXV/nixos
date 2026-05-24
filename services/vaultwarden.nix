{
  config,
  pkgs,
  lib,
  ...
}: let
  dataDir = config.services.vaultwarden.config.DATA_FOLDER;
  backup = {
    remote = "infini_cloud:vaultwarden";
    localStateDir = "/var/lib/vaultwarden-backup";
    remoteRetention = "90d";
    localRetention = "+7";
  };
  rcloneConfig = config.sops.secrets."rclone/config".path;
  backupScript = pkgs.writeShellApplication {
    name = "vaultwarden-backup";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnutar
      pkgs.rclone
      pkgs.rsync
      pkgs.sqlite
      pkgs.zstd
    ];
    text = ''
      set -o pipefail

      data_dir=${lib.escapeShellArg dataDir}
      work_dir=${lib.escapeShellArg backup.localStateDir}
      snapshot_dir="$work_dir/snapshot"
      archive_dir="$work_dir/archives"
      timestamp="$(date -u +"%Y%m%dT%H%M%SZ")"
      archive="$archive_dir/vaultwarden-$timestamp.tar.zst"

      umask 077
      rm -rf "$snapshot_dir"
      mkdir -p "$snapshot_dir" "$archive_dir"

      rsync -rlt --delete \
        --exclude "/db.sqlite3" \
        --exclude "/db.sqlite3-shm" \
        --exclude "/db.sqlite3-wal" \
        "$data_dir"/ "$snapshot_dir"/

      if [[ -f "$data_dir/db.sqlite3" ]]; then
        sqlite3 -readonly "$data_dir/db.sqlite3" ".backup '$snapshot_dir/db.sqlite3'"
      fi

      find "$snapshot_dir" -mindepth 1 -printf '%P\0' \
        | sort -z \
        | tar --create --file - \
          --directory "$snapshot_dir" \
          --null \
          --verbatim-files-from \
          --no-recursion \
          --files-from - \
          --mtime="@0" \
          --owner=0 \
          --group=0 \
          --numeric-owner \
        | zstd -T0 -19 -q > "$archive"

      rclone copy "$archive" ${lib.escapeShellArg backup.remote} \
        --config ${lib.escapeShellArg rcloneConfig} \
        --transfers 1

      rclone delete ${lib.escapeShellArg backup.remote} \
        --config ${lib.escapeShellArg rcloneConfig} \
        --min-age ${lib.escapeShellArg backup.remoteRetention} \
        --include "/vaultwarden-*.tar.zst" \
        --exclude "**"

      find "$archive_dir" -type f -name "vaultwarden-*.tar.zst" -mtime ${backup.localRetention} -delete
    '';
  };
in {
  services.vaultwarden = {
    enable = true;
    config = {
      DATA_FOLDER = "/var/lib/vaultwarden";
      DOMAIN = "https://syy-pc.taile2b66b.ts.net:8454";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8455;
    };
    webVaultPackage = pkgs.vaultwarden.webvault;
  };

  services.nginx.virtualHosts."syy-pc.taile2b66b.ts.net" = {
    http2 = true;
    listen = [
      {
        addr = "0.0.0.0";
        port = 8454;
        ssl = true;
      }
      {
        addr = "[::]";
        port = 8454;
        ssl = true;
      }
    ];

    forceSSL = true;
    sslCertificate = "/var/lib/tailscale/certs/syy-pc.taile2b66b.ts.net.crt";
    sslCertificateKey = "/var/lib/tailscale/certs/syy-pc.taile2b66b.ts.net.key";

    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        recommendedProxySettings = true;
      };

      "/notifications/hub" = {
        proxyPass = "http://127.0.0.1:8455";
        proxyWebsockets = true;
      };
    };
  };

  systemd.services.vaultwarden-backup = {
    description = "Back up Vaultwarden data to infini_cloud";
    after = ["network-online.target" "sops-nix.service"];
    wants = ["network-online.target"];

    environment = {
      HOME = backup.localStateDir;
      XDG_CACHE_HOME = "${backup.localStateDir}/cache";
    };

    unitConfig = {
      ConditionPathIsDirectory = dataDir;
      RequiresMountsFor = [dataDir backup.localStateDir];
    };

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupScript}/bin/vaultwarden-backup";
      StateDirectory = "vaultwarden-backup";
      StateDirectoryMode = "0700";
      UMask = "0077";

      CapabilityBoundingSet = ["CAP_DAC_OVERRIDE"];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      ReadWritePaths = [backup.localStateDir];
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
    };
  };

  systemd.timers.vaultwarden-backup = {
    description = "Run Vaultwarden backups";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "03:15";
      Persistent = true;
      RandomizedDelaySec = "45m";
      Unit = "vaultwarden-backup.service";
    };
  };
}
