{
  config,
  lib,
  ...
}:
let
  primaryUser = config.system.primaryUser;

  # User-session (Aqua GUI) background agents to disable.
  disabledGuiAgents = [
    # Siri & Dictation
    "com.apple.Siri.agent"
    "com.apple.campo"
    "com.apple.assistantd"
    "com.apple.assistant_service"
    "com.apple.assistant_cdmd"
    "com.apple.corespeechd"
    "com.apple.siri.context.service"
    "com.apple.siriactionsd"
    "com.apple.siriappintentsd"
    "com.apple.siriinferenced"
    "com.apple.siriknowledged"
    "com.apple.sirittsd"
    "com.apple.SiriTTSTrainingAgent"

    # Widgets, News & Weather
    "com.apple.chronod"
    "com.apple.newsd"
    "com.apple.weatherd"

    # Apple Intelligence & Proactive Suggestions
    "com.apple.generativeexperiencesd"
    "com.apple.GenerativeFunctions.agentstored"
    "com.apple.imageplaygroundd"
    "com.apple.intelligenceflowd"
    "com.apple.intelligencecontextd"
    "com.apple.intelligenceplatformd"
    "com.apple.intelligencetasksd"
    "com.apple.visualintelligenced"
    "com.apple.duetexpertd"
    "com.apple.suggestd"
    "com.apple.proactived"
    "com.apple.parsecd"
    "com.apple.hybridsearchd"
    "com.apple.textunderstandingd"
    "com.apple.spotlightknowledged"
    "com.apple.spotlightknowledged.updater"
    "com.apple.spotlightknowledged.importer"
    "com.apple.knowledge-agent"
    "com.apple.knowledgeconstructiond"
    "com.apple.ContextStoreAgent"
    "com.apple.biomesyncd"
    "com.apple.triald"

    # Telemetry, Marketing & Unused Apple Services
    "com.apple.ap.adprivacyd"
    "com.apple.analyticsagent"
    "com.apple.appleseed.seedusaged.postinstall"
    "com.apple.amsengagementd"
    "com.apple.routined"
    "com.apple.tipsd"
    "com.apple.homed"
    "com.apple.homeenergyd"
    "com.apple.financed"
    "com.apple.GamePolicyAgent"
    "com.apple.familycircled"

    # Photos & iCloud sync
    "com.apple.photolibraryd"
    "com.apple.photoanalysisd"
    "com.apple.cloudphotod"
    "com.apple.bird"
    "com.apple.cloudd"

    # Third-party updaters & leftover agents
    "com.sangfor.ECAgentProxy"
    "com.microsoft.update.agent"
  ];

  # System-wide telemetry & background intelligence daemons
  disabledSystemDaemons = [
    "com.apple.analyticsd"
    "com.apple.audioanalyticsd"
    "com.apple.geoanalyticsd"
    "com.apple.inputanalyticsd"
    "com.apple.wifianalyticsd"
    "com.apple.ecosystemanalyticsd"
    "com.apple.cloudtelemetryd"
    "com.apple.osanalytics.osanalyticshelper"
    "com.apple.coreduetd"
    "com.apple.knowledgeconstructiond"
    "com.apple.triald.system"
    "com.apple.contextstored"

    # Third-party updaters & leftover daemons
    "com.sangfor.EasyMonitor"
    "com.sangfor.limit.maxfiles"
    "com.microsoft.autoupdate.helper"
  ];

  mkDisableScript =
    domain: labels:
    lib.concatMapStringsSep "\n" (label: ''
      /bin/launchctl disable "${domain}/${label}" 2>/dev/null || true
      /bin/launchctl bootout "${domain}/${label}" 2>/dev/null || true
    '') labels;

  # nix-darwin's CustomSystemPreferences does not shell-escape domain paths,
  # so paths containing spaces must be written with explicit quoting.
  spacedSystemPreferences = {
    "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory" = {
      AutoSubmit = false;
      ThirdPartyDataSubmit = false;
    };

    "/Library/Managed Preferences/com.apple.AdLib" = {
      allowApplePersonalizedAdvertising = false;
      allowIdentifierForAdvertising = false;
    };

    "/Library/Managed Preferences/com.apple.applicationaccess" = {
      _isAppleIntelligenceRestricted = true;
      _manualProfile = true;
      allowApplePersonalizedAdvertising = false;
      allowAssistant = false;
      allowBookstore = false;
      allowDiagnosticSubmission = false;
      allowExternalIntelligenceIntegrations = false;
      allowExternalIntelligenceIntegrationsSignIn = false;
      allowGameCenter = false;
      allowGenmoji = false;
      allowImagePlayground = false;
      allowMailSmartReplies = false;
      allowMailSummary = false;
      allowNotesTranscriptionSummary = false;
      allowSafariSummary = false;
      allowSpotlightInternetResults = false;
      allowWritingTools = false;
    };

    "/Library/Managed Preferences/com.apple.assistant.managedconfiguration" = {
      allowSiriServerLogging = false;
    };

    "/Library/Managed Preferences/com.apple.assistant.support" = {
      "Assistant Enabled" = false;
      "Search Queries Data Sharing Status" = 2;
      "Siri Data Sharing Opt-In Status" = 2;
    };

    "/Library/Managed Preferences/com.apple.ironwood.support" = {
      "Assistant Allowed" = false;
    };

    "/Library/Managed Preferences/com.apple.Siri" = {
      StatusMenuVisible = false;
      VoiceTriggerUserEnabled = false;
    };

    "/Library/Managed Preferences/com.apple.lookup.shared" = {
      LookupSuggestionsDisabled = true;
    };

    "/Library/Managed Preferences/com.apple.Spotlight" = {
      parsecEnabled = false;
    };

    "/Library/Managed Preferences/com.apple.SubmitDiagInfo" = {
      AutoSubmit = false;
    };

    "/Library/Managed Preferences/com.apple.MobileAsset" = {
      "DownloadServerBaseURLOverride-com.apple.MobileAsset.UAF.FM.CodeLM" = "https://127.0.0.1:9/debloat-blocked/";
      "DownloadServerBaseURLOverride-com.apple.MobileAsset.UAF.FM.GenerativeModels" = "https://127.0.0.1:9/debloat-blocked/";
      "DownloadServerBaseURLOverride-com.apple.MobileAsset.UAF.FM.Visual" = "https://127.0.0.1:9/debloat-blocked/";
      "DownloadServerBaseURLOverride-com.apple.MobileAsset.UAF.Photos.MagicCleanup" = "https://127.0.0.1:9/debloat-blocked/";
      "DownloadServerBaseURLOverride-com.apple.MobileAsset.UAF.Photos.SpatialPhotosRelive" =
        "https://127.0.0.1:9/debloat-blocked/";
    };

    "/Library/Managed Preferences/com.apple.MobileSMS" = {
      messageSummarizationEnabled = false;
    };

    "/Library/Managed Preferences/com.apple.spatialphotosrelive" = {
      LocallyDisabled = true;
    };

    "/Library/Managed Preferences/group.com.apple.mail" = {
      DisableAutomaticMessageSummarization = true;
      PersonalizedSmartReplies = false;
    };

    "/Library/Managed Preferences/group.com.apple.usernoted" = {
      summarize_previews = false;
    };
  };

  mkSystemDefaultsScript =
    prefs:
    lib.concatStringsSep "\n" (
      lib.flatten (
        lib.mapAttrsToList (
          domain: attrs:
          lib.mapAttrsToList (
            key: value:
            "/usr/bin/defaults write ${lib.escapeShellArg domain} ${lib.escapeShellArg key} ${
              lib.escapeShellArg (lib.generators.toPlist { escape = true; } value)
            }"
          ) attrs
        ) prefs
      )
    );
in
{
  system.defaults = {
    universalaccess = {
      reduceMotion = true;
    };

    CustomUserPreferences = {
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
        allowIdentifierForAdvertising = false;
      };

      "com.apple.Siri" = {
        StatusMenuVisible = false;
        VoiceTriggerUserEnabled = false;
        UserHasDeclinedEnable = true;
      };

      "com.apple.assistant.support" = {
        "Assistant Enabled" = false;
        "Dictation Enabled" = false;
        "Search Queries Data Sharing Status" = 2;
        "Siri Data Sharing Opt-In Status" = 2;
      };

      "com.apple.assistant.backedup" = {
        "Cloud Sync Enabled" = 0;
        "Enable Offline Mode For Apple Intelligence" = 0;
      };

      "com.apple.CloudSubscriptionFeatures.optIn" = {
        "21749576137" = 0;
        "545129924" = false;
        "opted_out_buddy" = true;
      };

      "com.apple.lookup.shared" = {
        LookupSuggestionsDisabled = true;
      };

      "com.apple.Spotlight" = {
        parsecEnabled = false;
      };

      "com.apple.Safari" = {
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
      };

      "com.apple.suggestions" = {
        SuggestionsAllowGeocode = false;
      };

      "com.apple.chronod" = {
        remoteWidgetsEnabled = false;
      };
    };

    CustomSystemPreferences = {
      "/Library/Preferences/com.apple.SubmitDiagInfo" = {
        AutoSubmit = false;
      };
    };
  };

  system.activationScripts.postActivation.text = lib.mkAfter ''
    primary_uid=$(/usr/bin/id -u "${primaryUser}")

    /bin/mkdir -p "/Library/Managed Preferences" "/Library/Application Support/CrashReporter"
    ${mkSystemDefaultsScript spacedSystemPreferences}
    /bin/chmod 644 "/Library/Managed Preferences/"*.plist 2>/dev/null || true

    ${mkDisableScript "gui/$primary_uid" disabledGuiAgents}
    ${mkDisableScript "system" disabledSystemDaemons}

    /bin/launchctl asuser "$primary_uid" /usr/bin/sudo -u "${primaryUser}" \
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
  '';
}
