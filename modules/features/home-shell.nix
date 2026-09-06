{...}: {
  flake.modules.homeManager.shell = {
    imports = [../../home-manager/modules/config-fish];

    programs.bash.enable = true;
  };

  # Linux keeps the existing login-shell handoff and Linux-only helpers. On
  # macOS the login shell remains zsh, while fish is available explicitly.
  flake.modules.homeManager.linux-shell = {pkgs, ...}: {
    programs.bash.initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
