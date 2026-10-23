{pkgs, ...}: {
  programs.rbw = {
    enable = true;
    settings = {
      email = "ydsunyan123@gmail.com";
      base_url = "http://localhost:8455";
      lock_timeout = 3600;
      pinentry = pkgs.pinentry-tty;
    };
  };

  home.packages = [pkgs.pinentry-tty];
}
