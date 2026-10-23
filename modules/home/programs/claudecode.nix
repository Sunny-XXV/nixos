{pkgs, ...}: {
  programs.claude-code.enable = false;
  programs.claude-code.package = pkgs.claude-code;
  dotfiles.links.".claude/settings.json" = "claude/settings.json";
}
