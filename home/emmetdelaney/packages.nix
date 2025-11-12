{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Browsers
    ungoogled-chromium # For web apps only

    # Editor
    vscode # Code editor

    # Terminal
    kitty

    # Wayland essentials
    rofi # Application launcher
    waybar # Status bar
    mako # Notifications
    grim # Screenshots
    slurp # Region select for screenshots
    wl-clipboard # Clipboard utilities
    swaylock # Screen lock
    swaybg # Wallpaper

    # File manager
    xfce.thunar # GUI file manager

    # Essential CLI tools
    fd # Better find
    ripgrep # Better grep
    eza # Better ls with icons
    htop # System monitor
    direnv # Environment switcher

    # Network
    networkmanagerapplet

    # Bluetooth
    blueman

    # Password manager

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    inter # More readable system font

    # Work
    slack
    _1password-gui
  ];

  # Kitty terminal configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 16;
    };
    settings = {
      # Tokyo Night theme colors (inline)
      foreground = "#c0caf5";
      background = "#1a1b26";
      selection_foreground = "#1a1b26";
      selection_background = "#7dcfff";

      # Black
      color0 = "#15161e";
      color8 = "#414868";

      # Red
      color1 = "#f7768e";
      color9 = "#f7768e";

      # Green
      color2 = "#9ece6a";
      color10 = "#9ece6a";

      # Yellow
      color3 = "#e0af68";
      color11 = "#e0af68";

      # Blue
      color4 = "#7aa2f7";
      color12 = "#7aa2f7";

      # Magenta
      color5 = "#bb9af7";
      color13 = "#bb9af7";

      # Cyan
      color6 = "#7dcfff";
      color14 = "#7dcfff";

      # White
      color7 = "#c0caf5";
      color15 = "#c0caf5";

      # Cursor
      cursor = "#7dcfff";
      cursor_text_color = "#1a1b26";

      # Window
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };
  };

  # Direnv for automatic environment activation
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # LibreWolf browser configuration with privacy settings
  programs.librewolf = {
    enable = true;

    # Privacy and security settings
    settings = {
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

      # Disable telemetry (LibreWolf already does this, but being explicit)
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
  };

  # Set librewolf as default browser
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = ["librewolf.desktop"];
      "x-scheme-handler/http" = ["librewolf.desktop"];
      "x-scheme-handler/https" = ["librewolf.desktop"];
      "x-scheme-handler/about" = ["librewolf.desktop"];
      "x-scheme-handler/unknown" = ["librewolf.desktop"];
    };
  };
}
