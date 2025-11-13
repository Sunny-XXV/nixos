{pkgs, ...}: {
  programs.fish.plugins = [
    {
      name = "fzf-fish";
      src = pkgs.fishPlugins.fzf-fish.src;
    }
  ];
}
