{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };

      "github.com" = {
        AddKeysToAgent = "yes";
        HostName = "github.com";
        User = "git";
        IdentityFile = ["~/.ssh/id_ed25519"];
        IdentitiesOnly = true;
      };
    };
  };
}
