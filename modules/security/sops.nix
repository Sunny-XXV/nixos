{
  config,
  username,
  ...
}: {
  sops.age.keyFile = "${config.users.users.${username}.home}/.config/sops/age/keys.txt";
}
