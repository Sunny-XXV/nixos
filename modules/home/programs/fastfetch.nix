{pkgs, ...}: {
  home.packages = [pkgs.pokeget-rs];

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "command-raw";
        source = "pokeget random --hide-name";
        padding = {
          left = 3;
          right = 3;
          top = 2;
        };
      };
      modules = [
        "title"
        "separator"
        "datetime"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "wm"
        "font"
        {
          "type" = "cpu";
          "showPeCoreCount" = true;
          "temp" = true;
        }
        {
          "type" = "gpu";
          "driverSpecific" = true;
          "temp" = true;
        }
        "memory"
        "disk"
        {
          "type" = "battery";
          "temp" = true;
        }
        {
          "type" = "localip";
        }
        "locale"
        "break"
        "colors"
      ];
    };
  };
}
