{pkgs, ...}: let
  pinentryPackage =
    if pkgs.stdenv.hostPlatform.isDarwin
    then pkgs.pinentry_mac
    else pkgs.pinentry-tty;
in {
  home.packages = [pinentryPackage];

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

    pinentry.package = pinentryPackage;
  };
}
