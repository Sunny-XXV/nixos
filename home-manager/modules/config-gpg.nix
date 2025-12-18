{pkgs, ...}: {
  home.packages = [pkgs.pinentry-tty];

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;

    defaultCacheTtl = 600;
    maxCacheTtl = 7200;
    defaultCacheTtlSsh = 14400;
    maxCacheTtlSsh = 86400;

    pinentry = {
      package = pkgs.pinentry-tty;
      program = "pinentry";
    };
  };
}
