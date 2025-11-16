{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.chromium.override {
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,VulkanFromANGLE"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--ozone-platform-hint=auto"
      ];
    })
  ];
  programs.chromium.enable = true;
  programs.chromium.extensions = [];
}
