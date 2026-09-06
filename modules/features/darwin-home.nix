{...}: {
  flake.modules.homeManager.darwin = {
    pkgs,
    inputs,
    ...
  }: let
    pkgsExt = pkgs.extend inputs.vscode-extensions.overlays.default;
  in {
    home.homeDirectory = "/Users/sunya";

    # macOS-specific tools that were previously in the nix-darwin system
    # profile. They are user-facing, so Home Manager is their natural owner.
    home.packages = with pkgs; [
      gcc
      imagemagick
      qalculate-qt
      zathura
    ];

    # Homebrew owns the VSCodium application, while Home Manager owns its
    # extensions. A null package prevents Home Manager from installing a
    # second copy of the editor from nixpkgs.
    programs.vscodium = {
      enable = true;
      package = null;
      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = with pkgsExt.vscode-marketplace; [
          drcika.apc-extension
          fisheva.eva-theme
          pkgsExt.open-vsx.jeanp413.open-remote-ssh
          pkief.material-icon-theme
          vscodevim.vim
        ];
      };
    };
  };
}
