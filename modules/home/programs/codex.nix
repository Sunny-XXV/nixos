{pkgs, ...}: {
  programs.codex.enable = false;
  home.packages = [pkgs.codex];
  dotfiles.links.".codex/config.toml" = "codex/config.toml";
}
