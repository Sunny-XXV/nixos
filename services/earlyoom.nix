{
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
    extraArgs = [
      "--avoid"
      "^(sshd|tailscaled|systemd|nix_daemon)$"
      "--prefer"
      "^(java|python|chromium|docker)$"
    ];
  };
}
