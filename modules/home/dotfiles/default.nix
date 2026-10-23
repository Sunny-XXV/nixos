{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles;
in {
  options.dotfiles = {
    root = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/nixos/dotfiles";
      description = "Absolute path to the writable dotfiles checkout.";
    };

    links = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Home-relative targets mapped to paths under dotfiles.root.";
    };
  };

  config.home.file =
    lib.mapAttrs (_: source: {
      source = config.lib.file.mkOutOfStoreSymlink "${cfg.root}/${source}";
    })
    cfg.links;
}
