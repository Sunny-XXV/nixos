{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  vscodeExt = inputs.vscode-extensions.overlays.default pkgs pkgs;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  programs.vscodium = {
    enable = true;
  }
  // lib.optionalAttrs isDarwin {
    package = null;
    mutableExtensionsDir = false;
    profiles.default.extensions = with vscodeExt.vscode-marketplace; [
      drcika.apc-extension
      fisheva.eva-theme
      vscodeExt.open-vsx.jeanp413.open-remote-ssh
      pkief.material-icon-theme
      vscodevim.vim
    ];
  }
  // lib.optionalAttrs isLinux {
    profiles.default.enableExtensionUpdateCheck = false;
    profiles.default.enableUpdateCheck = false;
  };
}
