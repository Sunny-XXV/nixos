{
  description = "Syy's NixOS and nix-darwin systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    daeuniverse = {
      url = "github:daeuniverse/flake.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "git+https://github.com/zhaofengli/nix-homebrew.git";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pi = {
      url = "github:earendil-works/pi/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
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
    nix-darwin,
    ...
  }: let
    username = "sunya";
    commonSpecialArgs = {inherit inputs username;};
  in {
    nixosConfigurations.Syy-PC = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = commonSpecialArgs // {hostPlatform = "x86_64-linux";};
      modules = [./hosts/Syy-PC];
    };

    darwinConfigurations.Syy-Mac = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = commonSpecialArgs // {hostPlatform = "aarch64-darwin";};
      modules = [./hosts/Syy-Mac];
    };
  };
}
