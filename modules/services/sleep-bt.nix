{
  config,
  pkgs,
  username,
  ...
}: let
  home = config.users.users.${username}.home;
  toggleBluetooth = state:
    pkgs.writeShellScript "sleep-bt-${state}" ''
      exec ${pkgs.blueutil}/bin/blueutil -p ${state}
    '';
in {
  environment.systemPackages = with pkgs; [
    blueutil
    sleepwatcher
  ];

  home-manager.users.${username} = {
    home.file = {
      ".sleep".source = toggleBluetooth "0";
      ".wakeup".source = toggleBluetooth "1";
    };

    launchd.agents.sleep-bt = {
      enable = true;
      config = {
        Label = "homebrew.mxcl.sleepwatcher";
        ProgramArguments = [
          "${pkgs.sleepwatcher}/bin/sleepwatcher"
          "-V"
          "-s"
          "${home}/.sleep"
          "-w"
          "${home}/.wakeup"
        ];
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
