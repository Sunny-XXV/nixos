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
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };
  };

  homebrew.brews = [
    "mgba"
  ];

  homebrew.casks = [
    "calibre"
    "espanso"
    "helium-browser"
    # "input-source-pro"
    "karabiner-elements"
    "moonlight"
    "obs"
    "pearcleaner"
    "raycast"
    "readest"
    "retroarch-metal"
    "squirrel-app"
    "steam"
    "vscodium"
  ]
  ++ pinnedCasks [
    "aldente"
    "microsoft-word"
    "parallels-client"
    "tencent-meeting"
  ];
}
