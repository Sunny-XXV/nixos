{...}: {
  flake.modules.homeManager.darwin = {pkgs, ...}: {
    home.homeDirectory = "/Users/sunya";

    # macOS-specific tools that were previously in the nix-darwin system
    # profile. They are user-facing, so Home Manager is their natural owner.
    home.packages = with pkgs; [
      gcc
      imagemagick
      qalculate-qt
      zathura
    ];
  };
}
