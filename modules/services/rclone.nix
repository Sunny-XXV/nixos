{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  user = username;
  group = "users";
  rcloneConfig = config.sops.secrets."rclone/config".path;

  mounts = {
    infini_cloud = {
      remote = "infini_cloud:";
      mountPoint = "/mnt/infini_cloud";
    };
  };

  mkRcloneMount = name: mount: let
    mountScript = pkgs.writeShellScript "rclone-${name}-mount" ''
      exec ${pkgs.rclone}/bin/rclone mount ${mount.remote} ${mount.mountPoint} \
        --config ${rcloneConfig} \
        --allow-other \
        --umask 007 \
        --dir-cache-time 24h \
        --vfs-cache-mode writes \
        --vfs-cache-max-size 10G
    '';
  in {
    description = "Mount rclone remote ${mount.remote}";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "notify";
      User = user;
      Group = group;
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath [pkgs.rclone]}";
      ExecStart = mountScript;
      ExecStop = "/run/wrappers/bin/fusermount3 -u ${mount.mountPoint}";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
in {
  sops.secrets."rclone/config" = {
    sopsFile = ./rclone-secrets.yaml;
    key = "rclone_conf";
    owner = user;
    group = "root";
    mode = "0400";
  };

  environment.systemPackages = [pkgs.rclone];

  programs.fuse.enable = true;
  programs.fuse.userAllowOther = true;

  users.users.${user}.extraGroups = ["fuse"];

  systemd.tmpfiles.rules =
    builtins.map
    (mount: "d ${mount.mountPoint} 0770 ${user} ${group} - -")
    (builtins.attrValues mounts);

  systemd.services =
    lib.mapAttrs'
    (name: mount: {
      name = "rclone-${name}";
      value = mkRcloneMount name mount;
    })
    mounts;
}
