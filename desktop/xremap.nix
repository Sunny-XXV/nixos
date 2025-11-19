{
  inputs,
  ...
}: {
  hardware.uinput.enable = true;
  # users.groups.input.members = [ username ];
  # users.groups.uinput.members = [ username ];

  imports = [ inputs.xremap.nixosModules.default ];
  services.xremap = {
    enable = true;
    withNiri = true;
    # userName = username;
    # serviceMode = "user";
  };

  services.xremap.config.modmap = [
    {
      name = "CapsLock";
      remap = {
        "CapsLock" = {
          held = "Ctrl_L";
          tapped = "ESC";
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
      };
    }
  ];
}
