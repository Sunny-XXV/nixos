{
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  customDir = ../../../dotfiles/rime;
  customFiles = lib.attrNames (lib.filterAttrs (_: type: type == "regular") (builtins.readDir customDir));

  # Strip upstream sample files overridden by dotfiles/rime (e.g. custom_phrase.txt)
  # so Home Manager's recursive lndir merges cleanly without path collisions.
  rimeIceData = pkgs.runCommandLocal "rime-ice-data" { } ''
    cp -r ${pkgs.rime-ice}/share/rime-data $out
    chmod -R u+w $out
    rm -rf $out/build
    ${lib.concatMapStringsSep "\n" (name: "rm -f $out/${lib.escapeShellArg name}") customFiles}
  '';

  squirrelApp = "/Library/Input Methods/Squirrel.app/Contents";
  squirrelBin = "${squirrelApp}/MacOS/Squirrel";
  rimeDeployer = "${squirrelApp}/MacOS/rime_deployer";
  sharedSupport = "${squirrelApp}/SharedSupport";
in
lib.mkMerge [
  (lib.mkIf isDarwin {
    home.file = {
      "Library/Rime" = {
        source = rimeIceData;
        recursive = true;
      };

      "Library/Rime/.nix-rime-version" = {
        text = "${rimeIceData}\n";
        onChange = ''
          rm -rf "$HOME/Library/Rime/build"
          if [ -x "${rimeDeployer}" ]; then
            "${rimeDeployer}" --build "$HOME/Library/Rime" "${sharedSupport}" "$HOME/Library/Rime/build" || true
          fi
          if [ -x "${squirrelBin}" ]; then
            "${squirrelBin}" --reload || true
          fi
        '';
      };
    };

    dotfiles.links = lib.listToAttrs (
      map (name: {
        name = "Library/Rime/${name}";
        value = "rime/${name}";
      }) customFiles
    );
  })

  (lib.mkIf isLinux {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = [
          (pkgs.fcitx5-rime.override {
            rimeDataPkgs = [
              pkgs.rime-data
              pkgs.rime-ice
            ];
          })
        ];
      };
    };

    dotfiles.links =
      let
        linuxFiles = lib.filter (name: name != "squirrel.custom.yaml") customFiles;
      in
      lib.listToAttrs (
        map (name: {
          name = ".local/share/fcitx5/rime/${name}";
          value = "rime/${name}";
        }) linuxFiles
      );
  })
]
