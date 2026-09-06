{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.Syy-PC = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.nixos.syy-pc
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = {inherit inputs;};
          useGlobalPkgs = true;
          useUserPackages = true;
          users.sunya.imports = [
            config.flake.modules.homeManager.base
            config.flake.modules.homeManager.cli
            config.flake.modules.homeManager.shell
            config.flake.modules.homeManager.linux-shell
            config.flake.modules.homeManager.linux
          ];
        };
      }
    ];
  };
}
