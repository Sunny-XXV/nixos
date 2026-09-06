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
        autoUpdate = true;
        upgrade = true;
        # Homebrew is declarative: packages omitted from this module are
        # removed on the next activation. Avoid `zap` so application data is
        # retained when a cask is removed from the declaration.
        cleanup = "uninstall";
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
        "asmvik/formulae/yabai"
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
        "lizardbyte/homebrew/sunshine"
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
        # Office casks declare `auto_updates = true`. Keeping greedy disabled
        # makes normal activation ensure they are installed without upgrading
        # them. Upgrade Office only with an explicit command such as:
        #   brew upgrade --cask --greedy microsoft-excel microsoft-powerpoint microsoft-word
        {
          name = "microsoft-excel";
          greedy = false;
        }
        {
          name = "microsoft-powerpoint";
          greedy = false;
        }
        {
          name = "microsoft-word";
          greedy = false;
        }
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
