{pkgs, ...}: {
  programs.fish.plugins = [
    {
      name = "fzf";
      src = pkgs.fishPlugins.fzf-fish.src;
    }
  ];
}
