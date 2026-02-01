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

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    
    "vm.swappiness" = 10;
    
    "kernel.panic" = 10;
    "kernel.panic_on_oops" = 1;
  };
}
