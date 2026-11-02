{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  configTemplate = builtins.readFile ../../dotfiles/mihomo/config.template.yaml;
  configFile = config.sops.templates."mihomo-config.yaml".path;
  stateDir = "/Library/Application Support/mihomo";
  logFile = "/Library/Logs/mihomo.log";
in {
  environment.systemPackages = [pkgs.mihomo];

  sops = {
    age = {
      keyFile = "${config.users.users.${username}.home}/.config/sops/age/keys.txt";
      # Use only the dedicated SOPS identity, not macOS SSH host keys.
      sshKeyPaths = [];
    };
    gnupg.sshKeyPaths = [];

    secrets."mihomo/subscription_url" = {
      sopsFile = ./mihomo-secrets.yaml;
      key = "subscription_url";
      owner = "root";
      group = "wheel";
      mode = "0400";
    };

    secrets."mihomo/warp_private_key" = {
      sopsFile = ./mihomo-secrets.yaml;
      key = "warp_private_key";
      owner = "root";
      group = "wheel";
      mode = "0400";
    };

    secrets."mihomo/warp_ip6_address" = {
      sopsFile = ./mihomo-secrets.yaml;
      key = "warp_ip6_address";
      owner = "root";
      group = "wheel";
      mode = "0400";
    };

    templates."mihomo-config.yaml" = {
      content =
        builtins.replaceStrings
        [
          "@MIHOMO_SUBSCRIPTION_URL@"
          "@MIHOMO_WARP_PRIVATE_KEY@"
          "@MIHOMO_WARP_IP6_ADDRESS@"
        ]
        [
          config.sops.placeholder."mihomo/subscription_url"
          config.sops.placeholder."mihomo/warp_private_key"
          config.sops.placeholder."mihomo/warp_ip6_address"
        ]
        configTemplate;
      owner = "root";
      group = "wheel";
      mode = "0400";
    };
  };

  # TUN needs root privileges. Provider, UI, and database state stays outside
  # the repository; the subscription URL exists only in the SOPS-rendered file.
  launchd.daemons.mihomo = {
    path = [pkgs.coreutils];
    environment.SAFE_PATHS = "/run/secrets/rendered";
    script = ''
      for attempt in $(${pkgs.coreutils}/bin/seq 1 30); do
        test -r "${configFile}" && break
        ${pkgs.coreutils}/bin/sleep 1
      done
      test -r "${configFile}"

      mkdir -p "${stateDir}"
      chmod 700 "${stateDir}"

      exec ${pkgs.mihomo}/bin/mihomo -d "${stateDir}" -f "${configFile}"
    '';
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
      ThrottleInterval = 5;
    };
  };

  system.activationScripts.postActivation.text = lib.mkOrder 1600 ''
    if /bin/launchctl print system/org.nixos.mihomo >/dev/null 2>&1; then
      /bin/launchctl kickstart -k system/org.nixos.mihomo
    fi

    /usr/sbin/networksetup -setwebproxy "Wi-Fi" 127.0.0.1 7890 off
    /usr/sbin/networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 7890 off
    /usr/sbin/networksetup -setsocksfirewallproxystate "Wi-Fi" off
    /usr/sbin/networksetup -setautoproxystate "Wi-Fi" off
    /usr/sbin/networksetup -setproxybypassdomains "Wi-Fi" \
      localhost 127.0.0.1 ::1 "*.local" "*.ts.net" \
      169.254/16 10/8 100.64/10 172.16/12 192.168/16
  '';
}
