{pkgs, ...}: let
  llama-cpp = pkgs.llama-cpp.overrideAttrs (attrs: {
    version = "10582";
    src = attrs.src.overrideAttrs (_: {
      outputHash = "sha256-ZH5BEjkT+dn8NuZPOLFsXraT64GkguHCWMCsHdJANog=";
    });
    npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
  });
in {
  home.packages = [ llama-cpp ];
}
