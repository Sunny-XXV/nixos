{pkgs, ...}: let
  rbw-fish-completions =
    pkgs.runCommand "rbw-completions.fish" {
      nativeBuildInputs = [pkgs.rbw];
    } ''
      ${pkgs.rbw}/bin/rbw gen-completions fish > $out
    '';
in {
  programs.rbw = {
    enable = true;
    settings = {
      email = "ydsunyan123@gmail.com";
      base_url = "http://localhost:8455";
      lock_timeout = 3600;
      pinentry = pkgs.pinentry-tty;
    };
  };

  programs.fish = {
    completions = {
      rbw = builtins.readFile rbw-fish-completions;
    };
  };
}
