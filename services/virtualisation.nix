{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {};

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
}
