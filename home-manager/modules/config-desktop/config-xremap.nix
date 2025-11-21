{inputs, ...}: {
  imports = [inputs.xremap.homeManagerModules.default];
  services.xremap = {
    enable = true;
    watch = true;
    withNiri = true;
  };
  services.xremap.deviceNames = ["Keychron Keychron K3 Max"];
  systemd.user.services.xremap.Install.WantedBy = ["default.target"];

  services.xremap.config.modmap = [
    {
      name = "CapsLock";
      remap = {
        "CapsLock" = {
          skip_key_event = true;
          held = "Ctrl_L";
          alone = "ESC";
          alone_timeout_millis = 300;
        };
      };
    }
  ];

  services.xremap.config.keymap = [
    {
      name = "terminal";
      application = {only = ["Alacritty" "kitty" "foot"];};
      remap = {
        "Super-C" = "C-S-c";
        "Super-V" = "C-S-v";
      };
    }
    {
      name = "osx-like";
      application = {not = ["Alacritty" "kitty" "foot"];};
      remap = {
        "Super-c" = "C-c";
        "Super-v" = "C-v";
        "Super-x" = "C-x";
        "Super-z" = "C-z";
        "Super-a" = "C-a";
        "Super-f" = "C-f";
        "Super-s" = "C-s";
        "Super-w" = "C-w";
        "Super-t" = "C-t";
        "Super-o" = "C-o";
      };
    }
  ];
}
