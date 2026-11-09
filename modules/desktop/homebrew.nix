{username, ...}: let
  trustedTap = name: {
    inherit name;
    trusted = true;
  };

  pinnedCasks = map (name: {
    inherit name;
    greedy = false;
  });
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
    "barutsrb/tap"
  ];

  homebrew.brews = [
    "mgba"
  ];

  homebrew.casks =
    [
      "bettercmdtab"
      "calibre"
      "crossover"
      "espanso"
      "helium-browser"
      "input-source-pro"
      "karabiner-elements"
      "moonlight"
      "obs"
      "orbstack"
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
    ]
    ++ pinnedCasks [
      "aldente"
      "microsoft-word"
      "parallels-client"
    ];
}
