{username, ...}: {
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "podman" "audio" "video" "render" "input" "uinput"];
    packages = [];
  };

  users.users.guest = {
    isNormalUser = true;
    hashedPassword = "!";
    extraGroups = ["networkmanager" "podman" "audio" "video" "input" "uinput"];
    packages = [];
  };
}
