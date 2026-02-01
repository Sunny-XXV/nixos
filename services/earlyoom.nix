{
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
    extraArgs = [
      "--avoid"
      "^(sshd|tailscaled|systemd|login|fish|bash)$"
      "--prefer"
      "^(nix-daemon|cc1plus|c\+\+|cargo|rustc|go|java|python|chromium|docker)$"
    ];
  };
}
