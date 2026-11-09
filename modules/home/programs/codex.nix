{pkgs, ...}: {
  programs.codex.enable = false;
  dotfiles.links.".codex/config.toml" = "codex/config.toml";
}
