{ config, meta, ... }:
{
  sops.age.keyFile = "${config.users.users.${meta.username}.home}/.config/sops/age/keys.txt";
}
