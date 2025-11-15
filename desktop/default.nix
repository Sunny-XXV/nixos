{pkgs, ...}: {
  imports = [
    ./browser.nix
    ./gaming.nix
  ];
  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    fuzzel
    wl-clipboard
    xwayland-satellite
  ];

  services.pipewire.enable = true;
}
