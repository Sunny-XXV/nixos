{pkgs, ...}: {
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    cliphist
    xwayland-satellite
    wlr-randr
    grim
    ddcutil
  ];

  security.rtkit.enable = true;
  services.pipewire.enable = true;
  systemd.user.services.wireplumber.wantedBy = ["default.target"];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GDK_DEBUG = "portals";
  };
}
