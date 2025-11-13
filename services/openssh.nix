{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
    ports = [22 24247];
  };

  users.users.sunya = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJAJ0CBSOEo5ZSqEFcG1rQJk5QdxrbQcuIPcEczsLwH ydsunyan123@gmail.com"
    ];
  };
}
