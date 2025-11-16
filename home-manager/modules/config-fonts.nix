{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  fonts.fontconfig.antialiasing = true;

  fonts.fontconfig.configFile = {
    include-nix-profile-fonts = {
      enable = true;
      text = ''
        <?xml version = "1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <dir>NIX_PROFILE/lib/x11/fonts</dir>
          <dir>NIX_PROFILE/share/fonts</dir>
        </fontconfig>
      '';
    };
  };

}
