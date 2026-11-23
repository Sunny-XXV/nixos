{ meta, ... }:
{
  users.users.${meta.username} = {
    isNormalUser = true;
    description = meta.username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
      "audio"
      "video"
      "render"
      "input"
      "uinput"
    ];
    packages = [ ];
  };
}
