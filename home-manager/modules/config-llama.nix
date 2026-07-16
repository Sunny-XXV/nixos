{pkgs, ...}: let
  llama-cpp = pkgs.llama-cpp.overrideAttrs (attrs: {
    # When bumping this version, update both hashes from Nix's "got:" output:
    # src.outputHash for the llama.cpp source, and npmDepsHash for web UI deps.
    version = "9974";
    src = attrs.src.overrideAttrs (_: {
      outputHash = "sha256-m+lKFNTj/fkztiBJfC1PlfVOTQ9jSF6hGVkV0+6KTMg=";
    });
    npmDepsHash = "sha256-6s9skw1wzEfm9QKktTqea3J+oudQAsS6O2VnZEMXAdw=";
  });
in {
  home.packages = [llama-cpp];
}
