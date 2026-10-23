{
  inputs,
  lib,
  pkgs,
  ...
}: let
  pkgsExt = pkgs.extend inputs.vscode-extensions.overlays.default;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in {
  programs.vscodium =
    {enable = true;}
    // lib.optionalAttrs isDarwin {
      package = null;
      mutableExtensionsDir = false;
      profiles.default.extensions = with pkgsExt.vscode-marketplace; [
        drcika.apc-extension
        fisheva.eva-theme
        pkgsExt.open-vsx.jeanp413.open-remote-ssh
        pkief.material-icon-theme
        vscodevim.vim
      ];
    }
    // lib.optionalAttrs isLinux {
      profiles.default.enableExtensionUpdateCheck = false;
      profiles.default.enableUpdateCheck = false;
    };
}
