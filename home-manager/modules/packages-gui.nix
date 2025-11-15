{pkgs, ...}: {
  home.packages = with pkgs; [
    foot
    fuzzel
  ];
}
