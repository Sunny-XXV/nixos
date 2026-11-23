{
  description = "Syy's NixOS and nix-darwin systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      treefmt-nix,
      ...
    }:
    let
      meta = {
        username = "sunya";
        email = "ydsunyan123@gmail.com";
        hosts = {
          pc = "syy-pc";
          mac = "syy-mac";
        };
        tailnet = "taile2b66b.ts.net";
        sshKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJAJ0CBSOEo5ZSqEFcG1rQJk5QdxrbQcuIPcEczsLwH ydsunyan123@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpReUt3bToa+UM0TZx0aFGWBvWpFHBPb03sDsKDo7ab ydsunyan123@gmail.com"
        ];
      };
      commonSpecialArgs = {
        inherit inputs meta;
      };
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      treefmt = nixpkgs.lib.genAttrs systems (
        system:
        treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";
          programs = {
            deadnix.enable = true;
            statix = {
              enable = true;
              disabled-lints = [ "empty_pattern" ];
            };
            nixfmt = {
              enable = true;
              width = 120;
            };
          };
          settings.formatter = {
            deadnix.priority = 1;
            statix.priority = 2;
            nixfmt.priority = 3;
          };
        }
      );
    in
    {
      formatter = nixpkgs.lib.mapAttrs (_: eval: eval.config.build.wrapper) treefmt;

      checks = nixpkgs.lib.mapAttrs (_: eval: {
        formatting = eval.config.build.check self;
      }) treefmt;

      nixosConfigurations.Syy-PC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = commonSpecialArgs;
        modules = [ ./hosts/Syy-PC ];
      };

      darwinConfigurations.Syy-Mac = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = commonSpecialArgs;
        modules = [ ./hosts/Syy-Mac ];
      };
    };
}
