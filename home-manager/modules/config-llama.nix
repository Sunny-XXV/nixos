{pkgs, ...}: let
  llama-cpp = pkgs.llama-cpp.overrideAttrs (attrs: {
    # When bumping this version, update both hashes from Nix's "got:" output:
    # src.outputHash for the llama.cpp source, and npmDepsHash for web UI deps.
    version = "9672";
    src = attrs.src.overrideAttrs (_: {
      outputHash = "sha256-/0qfu4QT1CFt1zBmaMvWGiOiRLqHp2ovhdpiirmvMOU=";
    });
    npmDepsHash = "sha256-T6CpsyZ1zxU9uEr/9JcmABCrtaB9aCz2EpdTS0IJzX0=";
  });
in {
  home.packages = [llama-cpp];
}
