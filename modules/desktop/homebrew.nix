{ meta, ... }:
let
  # for already-installed casks added or removed here,
  # run `brew pin/unpin --cask <name>` once manually.
  pinnedCasks = map (name: {
    inherit name;
    postinstall = "brew pin --cask ${name}";
  });
in
{
  nix-homebrew = {
    enable = true;
    user = meta.username;
    autoMigrate = true;
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    user = meta.username;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
  };

  homebrew.brews = [
    "mgba"
  ];

  homebrew.casks = [
    "bettercmdtab"
    "calibre"
    "crossover"
    "espanso"
    "helium-browser"
    # "input-source-pro"
    "karabiner-elements"
    "moonlight"
    "obs"
    "orbstack"
    "pearcleaner"
    "raycast"
    "readest"
    "retroarch-metal"
    "squirrel-app"
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
