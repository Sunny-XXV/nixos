# Syy systems

One flake manages both hosts:

- `nixosConfigurations.Syy-PC` — x86_64 NixOS
- `darwinConfigurations.Syy-Mac` — Apple Silicon macOS

The repository follows the dendritic pattern. Every file below `modules/` is
a flake-parts module discovered by `import-tree`; feature files publish typed
NixOS, nix-darwin, or Home Manager modules under `flake.modules`. Host files
compose those feature modules into complete systems.

## Apply

```sh
# NixOS
sudo nixos-rebuild switch --flake ~/.config/nixos#Syy-PC

# macOS
sudo darwin-rebuild switch --flake ~/.config/nixos#Syy-Mac
```

Home Manager is embedded in both system configurations. On macOS,
`nix-homebrew` owns the Homebrew installation while nix-darwin generates and
applies the Brewfile. Declared formulae and casks are upgraded during activation;
undeclared Homebrew packages are uninstalled without `--zap`, preserving user
data. Microsoft Word, Excel, and PowerPoint are excluded from automatic cask
upgrades, and Microsoft AutoUpdate is set to manual mode. Upgrade those three
only when intended:

```sh
brew upgrade --cask --greedy microsoft-excel microsoft-powerpoint microsoft-word
```

## Layout

```text
modules/
  core.nix                 flake-parts module registry
  features/                reusable system and user aspects
  hosts/                   complete host compositions

home-manager/              lower-level modules and managed assets
hosts/Syy-PC/              NixOS hardware and host-specific settings
desktop/, services/        existing NixOS-only modules
```
