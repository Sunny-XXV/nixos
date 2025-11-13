{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };

      "github.com" = {
        addKeysToAgent = "yes";
        hostname = "github.com";
        user = "git";
        identityFile = ["~/.ssh/id_ed25519"];
        identitiesOnly = true;
      };
    };
  };
}
