{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixvim,
    ...
  }: {
    nixosConfigurations = {
      Syy-PC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/Syy-PC
          ./sys-boot.nix
          ./desktop
          ./lang-kbd.nix
          ./nix-conf.nix
          ./miscs.nix
          ./usr-packages.nix
          ./services

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sunya.imports = [
              ./home-manager
              nixvim.homeModules.nixvim
            ];
          }
        ];
      };
    };
  };
}
