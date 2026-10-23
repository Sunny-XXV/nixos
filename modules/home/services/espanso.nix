{config, lib, ...}: {
  services.espanso = {
    enable = true;
    configs.default = {
      show_notifications = false;
      extra_includes = [
        "${config.xdg.dataHome}/espanso/private.yml"
      ];
    };
  };

  launchd.agents.espanso.config.ProgramArguments = lib.mkForce [
    "${config.services.espanso.package}/Applications/Espanso.app/Contents/MacOS/espanso"
    "daemon"
  ];

  dotfiles.links = {
    ".config/espanso/match/base.yml" = "espanso/match/base.yml";
    ".config/espanso/match/packages/basic-emojis" = "espanso/match/packages/basic-emojis";
  };
}
