{inputs, ...}: {
  # Preserve the existing NixOS behavior while it is incrementally split into
  # feature aspects. The host consumes this as one typed NixOS module.
  flake.modules.nixos.syy-pc = {
    imports = [
      ../../hosts/Syy-PC
      ../../sys-boot.nix
      ../../desktop
      ../../lang-kbd.nix
      ../../nix-conf.nix
      ../../miscs.nix
      ../../usr-packages.nix
      ../../services
      inputs.daeuniverse.nixosModules.daed
      inputs.sops-nix.nixosModules.sops
    ];
  };
}
