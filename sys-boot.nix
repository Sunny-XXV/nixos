{
  config,
  pkgs,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  systemd = {
    settings.Manager = {
      WatchdogDevice = "/dev/watchdog";
      RuntimeWatchdogSec = "30s";
      RebootWatchdogSec = "5min";
      KExecWatchdogSec = "5min";
    };
  };
}
