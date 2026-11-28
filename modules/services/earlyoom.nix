{
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;
    freeSwapThreshold = 10;
    extraArgs = [
      "--avoid"
      "^(sshd|tailscaled|mihomo|dae|systemd|login|fish|bash)$"
      "--prefer"
      "^(nix-daemon|cc1plus|c\\+\\+|cargo|rustc|go|java|python|chromium|docker)$"
    ];
  };
}
