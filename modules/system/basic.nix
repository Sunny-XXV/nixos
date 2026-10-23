{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    rsync
    alejandra
  ];

  environment.variables.EDITOR = "nvim";
  environment.enableAllTerminfo = true;
}
