{
  config,
  inputs,
  ...
}: {
  flake.darwinConfigurations.Syy-Mac = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {inherit inputs;};
    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager
      config.flake.modules.darwin.syy-mac
      config.flake.modules.darwin.homebrew
      {
        home-manager = {
          backupFileExtension = "hm-backup";
          extraSpecialArgs = {inherit inputs;};
          useGlobalPkgs = true;
          useUserPackages = true;
          users.sunya.imports = [
            config.flake.modules.homeManager.base
            config.flake.modules.homeManager.cli
            config.flake.modules.homeManager.shell
            config.flake.modules.homeManager.darwin
          ];
        };
      }
    ];
  };
}
