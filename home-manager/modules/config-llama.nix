{pkgs, ...}: let
  llama-cpp = pkgs.llama-cpp.overrideAttrs (attrs: {
    version = "10362";
    src = attrs.src.overrideAttrs (_: {
      outputHash = "sha256-2pW5uATAU9503D+iUKWkCAGyBVpVyVhxabeV4wj2Kec=";
    });
    npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
  });
in {
  home.packages = [ llama-cpp ];
}
