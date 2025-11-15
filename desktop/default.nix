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
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
