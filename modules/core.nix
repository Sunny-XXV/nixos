{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];

  # This flake currently publishes host configurations rather than
  # per-system packages, apps, or development shells.
  systems = [];
}
