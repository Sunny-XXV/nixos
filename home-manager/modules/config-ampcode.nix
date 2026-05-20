{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    amp-cli
  ];

  xdg.configFile."amp/settings.jsonc".text = ''
    {
      "amp.anthropic.thinking.enabled": true,
      "amp.notifications.enabled": true,
      "amp.git.commit.ampThread.enabled": false,
      "amp.git.commit.coauthor.enabled": false,
      "amp.updates.mode": "disabled",
      "amp.commands.allowlist": ["git status", "npm run build"],
      "amp.commands.loadUserEnvironment": true
    }
  '';
}
