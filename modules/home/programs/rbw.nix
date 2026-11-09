{pkgs, ...}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  pinentryPackage =
    if isDarwin
    then pkgs.pinentry_mac
    else pkgs.pinentry-tty;
in {
  programs.rbw = {
    enable = true;
    settings = {
      email = "ydsunyan123@gmail.com";
      base_url =
        if isDarwin
        then "https://syy-pc.taile2b66b.ts.net:8454"
        else "http://localhost:8455";
      lock_timeout = 3600;
      pinentry = pinentryPackage;
    };
  };

  home.packages = [pinentryPackage];
}
