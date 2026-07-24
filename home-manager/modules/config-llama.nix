{pkgs, ...}: let
  llama-cpp = pkgs.llama-cpp.overrideAttrs (attrs: {
    # When bumping this version, update both hashes from Nix's "got:" output:
    # src.outputHash for the llama.cpp source, and npmDepsHash for web UI deps.
    version = "10107";
    src = attrs.src.overrideAttrs (_: {
      outputHash = "sha256-g0rhl6tE3fuB7/fs1YUAkJxxTYpKBNVeFV5BDbXh29A=";
    });
    npmDepsHash = "sha256-B7uEynAG70a3xauBKc20RuFa9cnWaWzVBCh+LPLBnIM=";
  });
in {
  home.packages = [ llama-cpp ];
}
