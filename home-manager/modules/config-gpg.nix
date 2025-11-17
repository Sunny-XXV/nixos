{pkgs, ...}: {
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;
    pinentry = {
      package = pkgs.pinentry-tty;
      program = "pinentry";
    };
  };
}
