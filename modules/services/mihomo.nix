{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  isDarwin = options ? launchd;
  isLinux = options ? systemd;

  tunDevice = "mihomo";
  mixedPort = 7890;
  controllerPort = 9090;

  mkSecret = key: {
    sopsFile = ./mihomo-secrets.yaml;
    inherit key;
  };

  overlay = {
    proxy-providers = {
      nachoneko.url = config.sops.placeholder."mihomo/sub_nacho";
      pokemon.url = config.sops.placeholder."mihomo/sub_pokem";
    };
    proxies.warp = {
      ipv6 = config.sops.placeholder."mihomo/warp_ip6_address";
      private-key = config.sops.placeholder."mihomo/warp_private_key";
    };
  }
  // lib.optionalAttrs isLinux {
    # Reachable via lo and tailscale0 (trustedInterfaces); blocked on LAN/WAN by networking.firewall.
    external-controller = "0.0.0.0:${toString controllerPort}";
    # auto-detect-interface binds #DIRECT to the physical NIC; bind MagicDNS queries explicitly to tailscale0.
    dns.nameserver-policy."+.ts.net" = "100.100.100.100#tailscale0";
    tun = {
      device = tunDevice;
      auto-redirect = true;
      gso = true;
      gso-max-size = 65536;
      exclude-interface = [ "tailscale0" ];
    };
  }
  // lib.optionalAttrs isDarwin {
    external-controller = "127.0.0.1:${toString controllerPort}";
  };

  configTemplate =
    pkgs.runCommand "mihomo-config-template.yaml"
      {
        nativeBuildInputs = [ pkgs.yq-go ];
        baseConfig = ../../dotfiles/mihomo/config.yaml;
        overlayJson = builtins.toJSON overlay;
        passAsFile = [ "overlayJson" ];
      }
      ''
        yq eval-all --yaml-fix-merge-anchor-to-spec=true '
          select(fileIndex == 0) as $base |
          (select(fileIndex == 1) | ... style="") as $o |
          $base |
          .["proxy-providers"].nachoneko.url = $o["proxy-providers"].nachoneko.url |
          .["proxy-providers"].pokemon.url = $o["proxy-providers"].pokemon.url |
          (.proxies[] | select(.name == "WARP")) |= (. + $o.proxies.warp) |
          .["external-controller"] = $o["external-controller"] |
          .dns *= ($o.dns // {}) |
          .tun *= ($o.tun // {})
        ' "$baseConfig" "$overlayJsonPath" > "$out"
      '';

  configFile = config.sops.templates."mihomo-config.yaml".path;

  darwinStateDir = "/Library/Application Support/mihomo";
  darwinFingerprintFile = "${darwinStateDir}/.config.sha256";
  darwinLogFile = "/Library/Logs/mihomo.log";
in
{
  config = lib.mkMerge [
    {
      environment.systemPackages = [ pkgs.mihomo ];

      sops = {
        secrets = {
          "mihomo/sub_nacho" = mkSecret "sub_nacho";
          "mihomo/sub_pokem" = mkSecret "sub_pokem";
          "mihomo/warp_private_key" = mkSecret "warp_private_key";
          "mihomo/warp_ip6_address" = mkSecret "warp_ip6_address";
        };

        templates."mihomo-config.yaml" = {
          file = configTemplate;
        }
        // lib.optionalAttrs isLinux {
          restartUnits = [ "mihomo.service" ];
        };
      };
    }

    (lib.optionalAttrs isLinux {
      services.mihomo = {
        enable = true;
        package = pkgs.mihomo;
        inherit configFile;
        webui = pkgs.zashboard;
        tunMode = true;
        processesInfo = true;
      };

      systemd.services.mihomo = {
        # Order after tailscaled so tailscale0 exists for exclude-interface, while keeping
        # tailscaled independent of mihomo so Tailscale SSH survives if proxy nodes fail.
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
        environment.SAFE_PATHS = "${pkgs.zashboard}";
        serviceConfig = {
          # Appended to CAP_NET_ADMIN / CAP_DAC_READ_SEARCH / CAP_SYS_PTRACE from services.mihomo;
          # CAP_NET_RAW is required for ICMP, WireGuard, and raw socket operations in TUN mode.
          AmbientCapabilities = [ "CAP_NET_RAW" ];
          CapabilityBoundingSet = [ "CAP_NET_RAW" ];
          LimitNOFILE = 1048576;
          MemoryHigh = "512M";
          MemoryMax = "1G";
          Restart = "on-failure";
          RestartSec = "3s";
        };
      };

      # Allow traffic redirected from the TUN interface by Mihomo's auto-redirect nftables rules.
      networking.firewall.trustedInterfaces = [ tunDevice ];
    })

    (lib.optionalAttrs isDarwin {
      # TUN needs root privileges. Provider and database state stays outside the
      # repository; subscription URLs and keys exist only in the SOPS-rendered file.
      launchd.daemons.mihomo = {
        path = [ pkgs.coreutils ];
        environment.SAFE_PATHS = "${builtins.dirOf configFile}:${pkgs.zashboard}";
        script = ''
          for _ in $(seq 1 30); do
            test -r "${configFile}" && break
            sleep 1
          done
          test -r "${configFile}"

          mkdir -p "${darwinStateDir}"
          chmod 700 "${darwinStateDir}"
          sha256sum "${configFile}" > "${darwinFingerprintFile}"

          exec ${lib.getExe pkgs.mihomo} -d "${darwinStateDir}" -f "${configFile}" -ext-ui "${pkgs.zashboard}"
        '';
        serviceConfig = {
          RunAtLoad = true;
          KeepAlive = true;
          ProcessType = "Background";
          StandardOutPath = darwinLogFile;
          StandardErrorPath = darwinLogFile;
          ThrottleInterval = 5;
        };
      };

      # Order 1600 runs after sops-nix postActivation (mkAfter = 1500) updates configFile.
      # Only restart mihomo when configFile actually changed to avoid dropping active connections.
      system.activationScripts.postActivation.text = lib.mkOrder 1600 ''
        if /bin/launchctl print system/org.nixos.mihomo >/dev/null 2>&1; then
          if [ -r "${configFile}" ] && ! ${pkgs.coreutils}/bin/sha256sum --status -c "${darwinFingerprintFile}" >/dev/null 2>&1; then
            /bin/launchctl kickstart -k system/org.nixos.mihomo
          fi
        fi

        /usr/sbin/networksetup -setwebproxy "Wi-Fi" 127.0.0.1 ${toString mixedPort} off
        /usr/sbin/networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 ${toString mixedPort} off
        /usr/sbin/networksetup -setsocksfirewallproxystate "Wi-Fi" off
        /usr/sbin/networksetup -setautoproxystate "Wi-Fi" off
        /usr/sbin/networksetup -setproxybypassdomains "Wi-Fi" \
          localhost 127.0.0.1 ::1 "*.local" "*.ts.net" \
          169.254/16 10/8 100.64/10 172.16/12 192.168/16
      '';
    })
  ];
}
