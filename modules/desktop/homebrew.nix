{username, ...}: let
  trustedTap = name: {
    inherit name;
    trusted = true;
  };
in {
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    user = username;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
  };

  homebrew.taps = map trustedTap [
    "acsandmann/tap"
    "barutsrb/tap"
  ];

  homebrew.brews = [
    "acsandmann/tap/rift"
    "mgba"
  ];

  homebrew.casks = [
    "bettercmdtab"
    "calibre"
    "crossover"
    "espanso"
    "helium-browser"
    "input-source-pro"
    "karabiner-elements"
    "moonlight"
    {
      name = "microsoft-word";
      greedy = false;
    }
    "obs"
    "orbstack"
    "parallels-client"
    "pearcleaner"
    "raycast"
    "readest"
    "retroarch-metal"
    "squirrel-app"
    "stats"
    "steam"
    "tencent-meeting"
    "vscodium"
    "zed"
    "zotero"
  ];
}
