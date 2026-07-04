{pkgs, ...}: let
  llama-cpp = pkgs.llama-cpp.overrideAttrs (attrs: {
    # When bumping this version, update both hashes from Nix's "got:" output:
    # src.outputHash for the llama.cpp source, and npmDepsHash for web UI deps.
    version = "9870";
    src = attrs.src.overrideAttrs (_: {
      outputHash = "sha256-htIMo3pOldoELyHyGIZ4voUJeay3fymIIRy89Z8gNK8=";
    });
    npmDepsHash = "sha256-X1DZgmhS/zHTqDT5zq0kywwntthcJ9vRXeqyO3zz6UU=";
  });
in {
  home.packages = [llama-cpp];
}
