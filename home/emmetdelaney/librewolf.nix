{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.librewolf;
in {
  options.programs.librewolf = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable LibreWolf browser";
    };

    profileName = mkOption {
      type = str;
      default = "default";
      description = "LibreWolf profile name";
    };

    settings = mkOption {
      type = attrsOf (oneOf [bool int str]);
      default = {};
      description = "LibreWolf preferences to set in user.js";
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = "Extra lines to add to user.js";
    };

    userChrome = mkOption {
      type = lines;
      default = "";
      description = "CSS Styles for LibreWolf's interface";
    };

    userContent = mkOption {
      type = lines;
      default = "";
      description = "Global CSS Styles for websites";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;
      policies = {
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        DisableAppUpdate = true;
      };
    };

    # Use XDG directories
    home.sessionVariables = {
      XDG_FAKE_HOME = config.home.homeDirectory;
    };

    # Wrapper script to obey XDG
    home.packages = [
      (pkgs.writeShellScriptBin "librewolf" ''
        export HOME="$XDG_FAKE_HOME"
        exec "${config.programs.firefox.package}/bin/librewolf" "$@"
      '')
    ];

    # Treat LibreWolf as default PDF reader
    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "librewolf.desktop";
    };

    # Default privacy-focused settings
    programs.librewolf.settings = {
      # Allow svgs to take on theme colors
      "svg.context-properties.content.enabled" = true;

      # Better keyboard navigation
      "browser.toolbars.keyboard_navigation" = false;

      # Disable translation popups
      "browser.translations.automaticallyPopup" = false;

      # Enable ETP for decent security
      "browser.contentblocking.category" = "strict";
      "privacy.donottrackheader.enabled" = true;
      "privacy.donottrackheader.value" = 1;
      "privacy.purge_trackers.enabled" = true;

      # Sync toolbar customization
      "services.sync.prefs.sync.browser.uiCustomization.state" = true;

      # Enable userContent.css and userChrome.css
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      # Download directory
      "browser.download.dir" = "${config.home.homeDirectory}/downloads";

      # Disable built-in password manager
      "signon.rememberSignons" = false;

      # Don't check if Firefox is default browser
      "browser.shell.checkDefaultBrowser" = false;

      # Disable new tab page
      "browser.newtabpage.enabled" = false;
      "browser.newtab.url" = "about:blank";

      # Disable Activity Stream
      "browser.newtabpage.activity-stream.enabled" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;

      # Disable new tab tile ads & preload
      "browser.newtabpage.enhanced" = false;
      "browser.newtabpage.introShown" = true;
      "browser.newtab.preload" = false;
      "browser.newtabpage.directory.ping" = "";
      "browser.newtabpage.directory.source" = "data:text/plain,{}";

      # Reduce search engine noise
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.shortcuts.bookmarks" = false;
      "browser.urlbar.shortcuts.history" = false;
      "browser.urlbar.shortcuts.tabs" = false;
      "browser.urlbar.showSearchSuggestionsFirst" = false;
      "browser.urlbar.speculativeConnect.enabled" = false;
      "browser.urlbar.resultMenu.keyboardAccessible" = false;
      "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;

      # Show whole URL in address bar
      "browser.urlbar.trimURLs" = false;

      # Disable annoying features
      "browser.disableResetPrompt" = true;
      "browser.onboarding.enabled" = false;
      "browser.aboutConfig.showWarning" = false;
      "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
      "extensions.pocket.enabled" = false;
      "extensions.unifiedExtensions.enabled" = false;
      "extensions.shield-recipe-client.enabled" = false;
      "reader.parse-on-load.enabled" = false;

      # Security-oriented defaults
      "security.family_safety.mode" = 0;
      "security.pki.sha1_enforcement_level" = 1;
      "security.tls.enable_0rtt_data" = false;
      "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
      "geo.provider.use_gpsd" = false;

      # Disable extension recommendations
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "extensions.htmlaboutaddons.discover.enabled" = false;
      "extensions.getAddons.showPane" = false;
      "browser.discovery.enabled" = false;

      # Reduce File IO / SSD abuse
      "browser.sessionstore.interval" = "1800000";

      # Disable battery API
      "dom.battery.enabled" = false;

      # Disable beacon
      "beacon.enabled" = false;

      # Disable pinging URIs
      "browser.send_pings" = false;

      # Disable gamepad API
      "dom.gamepad.enabled" = false;

      # Don't guess domain names
      "browser.fixup.alternate.enabled" = false;

      # Disable telemetry
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
      "experiments.supported" = false;
      "experiments.enabled" = false;
      "experiments.manifest.uri" = "";
      "browser.ping-centre.telemetry" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";
      "app.shield.optoutstudies.enabled" = false;

      # Disable health reports
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.healthreport.service.enabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;

      # Disable crash reports
      "breakpad.reportURL" = "";
      "browser.tabs.crashReporting.sendReport" = false;
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

      # Disable Form autofill
      "browser.formfill.enable" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.available" = "off";
      "extensions.formautofill.creditCards.available" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "extensions.formautofill.heuristics.enabled" = false;
    };

    # Profile configuration
    home.file = let
      localDir = "${config.home.homeDirectory}/.librewolf";
    in {
      "${localDir}/profiles.ini".text = ''
        [Profile0]
        Name=default
        IsRelative=1
        Path=${cfg.profileName}.default
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';

      "${localDir}/${cfg.profileName}.default/user.js" = mkIf (cfg.settings != {} || cfg.extraConfig != "") {
        text = ''
          ${concatStrings (mapAttrsToList (name: value: ''
              user_pref("${name}", ${builtins.toJSON value});
            '')
            cfg.settings)}
          ${cfg.extraConfig}
        '';
      };

      "${localDir}/${cfg.profileName}.default/chrome/userChrome.css" =
        mkIf (cfg.userChrome != "") {text = cfg.userChrome;};

      "${localDir}/${cfg.profileName}.default/chrome/userContent.css" =
        mkIf (cfg.userContent != "") {text = cfg.userContent;};
    };
  };
}
