{
  config,
  lib,
  ...
}: {
  services.espanso = {
    enable = true;
    configs.default = {
      search_trigger = ".search";
      search_shortcut = "off";
      show_icon = false;
      show_notifications = false;
    };
  };

  dotfiles.links = {
    ".config/espanso/match/base.yml" = "espanso/match/base.yml";
    ".config/espanso/match/packages/basic-emojis" = "espanso/match/packages/basic-emojis";
  };

  launchd.agents.espanso.config.ProgramArguments = lib.mkForce [
    "${config.services.espanso.package}/Applications/Espanso.app/Contents/MacOS/espanso"
    "daemon"
  ];

  programs.fish.functions.espanso-restart = {
    description = "Restart the Home Manager-managed Espanso service";
    body = ''
      set -l launchd_target "gui/"(command id -u)"/org.nix-community.home.espanso"
      /bin/launchctl kickstart -k $launchd_target
    '';
  };
}
