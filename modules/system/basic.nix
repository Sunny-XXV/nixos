{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    rsync
    nixfmt
  ];

  environment.variables.EDITOR = "nvim";
  environment.enableAllTerminfo = true;
}
