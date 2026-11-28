{
  meta,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  programs.rbw = {
    enable = true;
    settings = {
      inherit (meta) email;
      base_url = if isDarwin then "https://${meta.hosts.pc}.${meta.tailnet}:8454" else "http://localhost:8455";
      lock_timeout = 3600;
      pinentry = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-tty;
    };
  };
}
