{...}: {
  flake.modules.homeManager.linux = {
    imports = [
      ../../home-manager/modules/config-claudecode.nix
      ../../home-manager/modules/config-codex.nix
      ../../home-manager/modules/config-desktop
      ../../home-manager/modules/config-gpg.nix
      ../../home-manager/modules/config-llama.nix
      ../../home-manager/modules/config-secrets
      ../../home-manager/modules/config-ssh.nix
    ];

    home.homeDirectory = "/home/sunya";
  };
}
