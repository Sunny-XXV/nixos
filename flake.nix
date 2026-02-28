{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  }: {
    nixosConfigurations = {
      Syy-PC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

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
            home-manager.extraSpecialArgs = {inherit inputs;};

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sunya.imports = [
              ./home-manager
            ];
          }
        ];
      };
    };

    darwinConfigurations = {
      Syy-Mac = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};

        modules = [
          ./hosts/Syy-Mac

          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = {inherit inputs;};

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sunya.imports = [
              ./home-manager
            ];
          }
        ];
      };
    };
  };
}
