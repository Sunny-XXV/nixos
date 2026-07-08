let
  user = "sunya";
in {
  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
}
