{...}: {
  flake.modules.darwin.homebrew = {
    nix-homebrew = {
      enable = true;
      user = "sunya";
      autoMigrate = true;
      mutableTaps = true;
      trust.taps = [
        "acsandmann/tap"
        "asmvik/formulae"
        "barutsrb/tap"
        "homebrew-zathura/zathura"
        "laishulu/homebrew"
        "lizardbyte/homebrew"
        "railwaycat/emacsmacport"
      ];
    };

    homebrew = {
      enable = true;
      user = "sunya";

      onActivation = {
        autoUpdate = false;
        upgrade = false;
        # Start non-destructively. Change to "uninstall" only after the
        # generated Brewfile has been reviewed on the target Mac.
        cleanup = "none";
      };

      taps = [
        {
          name = "acsandmann/tap";
          trusted = true;
        }
        {
          name = "asmvik/formulae";
          trusted = true;
        }
        {
          name = "barutsrb/tap";
          trusted = true;
        }
        "homebrew-zathura/zathura"
        "homebrew/services"
        {
          name = "laishulu/homebrew";
          trusted = true;
        }
        {
          name = "lizardbyte/homebrew";
          trusted = true;
        }
        {
          name = "railwaycat/emacsmacport";
          trusted = true;
        }
      ];

      brews = [
        "argc"
        "autoconf"
        "automake"
        "blueutil"
        "coreutils"
        "ffmpeg"
        "ffmpegthumbnailer"
        "fish"
        "gnu-sed"
        "gnutls"
        "harfbuzz"
        "jansson"
        "libgccjit"
        "librsvg"
        "libxml2"
        "media-info"
        "mgba"
        "mihomo"
        "minicom"
        "mosh"
        "node"
        "pkgconf"
        "python-lsp-server"
        "scrcpy"
        {
          name = "sleepwatcher";
          restart_service = "changed";
        }
        "steamguard-cli"
        "texinfo"
        "typst"
        "uv"
        "watch"
        "yt-dlp"
        {
          name = "acsandmann/tap/rift";
          trusted = true;
        }
      ];

      casks = [
        "aldente"
        "alt-tab"
        "android-platform-tools"
        "betterdisplay"
        "calibre"
        "cleanshot"
        "codex"
        "dbeaver-community"
        "espanso"
        "font-jetbrains-mono-nerd-font"
        {
          name = "laishulu/homebrew/font-sarasa-nerd";
          trusted = true;
        }
        "ghostty"
        "helium-browser"
        "hiddenbar"
        "iina"
        "input-source-pro"
        "iterm2"
        "karabiner-elements"
        "maccy"
        "microsoft-excel"
        "microsoft-powerpoint"
        "microsoft-word"
        "mono-mdk-for-visual-studio"
        "moonlight"
        "obs"
        "orbstack"
        "parallels-client"
        "pearcleaner"
        "qbittorrent"
        "raycast"
        "readest"
        "retroarch-metal"
        "sioyek"
        "squirrel-app"
        "stats"
        "steam"
        "tailscale-app"
        "telegram"
        "tencent-meeting"
        "vscodium"
        "zed"
        "zotero"
      ];

      vscode = [
        "drcika.apc-extension"
        "fisheva.eva-theme"
        "jeanp413.open-remote-ssh"
        "pkief.material-icon-theme"
        "vscodevim.vim"
      ];

      # Homebrew Bundle is also the source of truth for the existing global
      # npm tools. These are kept here until they are packaged in Nix/HM.
      extraConfig = ''
        npm "@anthropic-ai/claude-code"
        npm "@modelcontextprotocol/server-sequential-thinking"
      '';
    };
  };
}
