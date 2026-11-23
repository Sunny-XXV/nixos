{
  pkgs,
  ...
}:
{
  programs.pi-coding-agent = {
    enable = true;
    extraPackages = [ pkgs.nodejs ];
  };
}
