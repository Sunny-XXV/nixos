{ pkgs, ... }:
let
  llama-cpp = pkgs.llama-cpp.overrideAttrs(attrs: {
    version = "9581";
    src = attrs.src.overrideAttrs (_: {
      outputHash = "sha256-M8FB0agUYghFKpJlXLOr9vYSVOUFEReEla5qoj8EbOA=";
    });
    npmDepsHash = "sha256-pjdbI6NcZRlJVd62xhgbLhWrwFYwgsIwjORqvo1+VD8=";
  });
in
{
  home.packages = [ llama-cpp ];
}
