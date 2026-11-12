{lib, ...}: {
  system = {
    defaults = {
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 14;
        KeyRepeat = 1;

        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        NSWindowShouldDragOnGesture = true;

        AppleInterfaceStyle = "Dark";
        AppleICUForce24HourTime = true;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
      };

      universalaccess = {
        reduceTransparency = true;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.15;
        show-recents = false;
        orientation = "right";
        minimize-to-application = true;
        mru-spaces = false;
        persistent-apps = [];
      };

      finder = {
        ShowPathbar = true;
        AppleShowAllExtensions = true;
        FXDefaultSearchScope = "SCcf";
        _FXShowPosixPathInTitle = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
      };

      WindowManager = {
        EnableStandardClickToShowDesktop = false;
        EnableTiledWindowMargins = false;
        HideDesktop = true;
      };

      trackpad = {
        Clicking = true;
      };

      screencapture = {
        target = "clipboard";
      };

      menuExtraClock = {
        Show24Hour = true;
        ShowDayOfWeek = true;
        ShowSeconds = true;
        ShowDate = 0;
      };

      CustomUserPreferences = {
        "com.microsoft.autoupdate2" = {HowToCheck = "Manual";};

        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.CrashReporter" = {DialogType = "none";};
      };

      CustomSystemPreferences = {
        "/Library/Preferences/FeatureFlags/Domain/UIKit.plist" = {
          redesigned_text_cursor = {Enabled = false;};
        };
      };
    };

    activationScripts.postActivation.text = lib.mkAfter ''
      /usr/bin/pmset -b powernap 0 2>/dev/null || true
      /usr/bin/pmset -b tcpkeepalive 0 2>/dev/null || true

      /usr/bin/hidutil property --set '{"CapsLockDelayOverride":0}' 2>/dev/null || true
       
      /usr/bin/killall -9 CursorUIViewService 2>/dev/null || true
    '';
  };

  launchd.user.agents.no-capslock-delay = {
    serviceConfig = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        "{\"CapsLockDelayOverride\":0}"
      ];
      RunAtLoad = true;
    };
  };
}
