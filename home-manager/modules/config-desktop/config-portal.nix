{pkgs, ...}: let
  yazi-picker = pkgs.writeShellScriptBin "yazi-picker" ''
    echo "Revieved args: $@" >> /tmp/yazi-picker.log

    mtp="$1"
    dir="$2"
    sav="$3"
    pth="$4"
    out="$5"

    cmd=( "${pkgs.yazi}/bin/yazi" )

    if [ "$sav" = "1" ]; then
      cmd+=( "--chooser-file=$out" )
    elif [ "$dir" = "1" ]; then
      cmd+=( "--chooser-file=$out" "--cwd-file=$out" )
    else
      cmd+=( "--chooser-file=$out" )
    fi

    if [ -n "$pth" ]; then
      cmd+=( "pth" )
    fi

    exec "''${cmd[@]}"
  '';
in {
  home.packages = [yazi-picker];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-termfilechooser
    xdg-desktop-portal-gtk
  ];
  xdg.portal.config.common = {
    default = ["gtk"];
    "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${pkgs.foot}/bin/foot -T FilePicker -e ${yazi-picker}/bin/yazi-picker
    default_dir=$HOME
  '';
}
