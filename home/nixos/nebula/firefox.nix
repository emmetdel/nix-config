({
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;

    # Optional: Set Firefox as default browser
    # You can also set this system-wide in your NixOS config
    # xdg.defaultApplications."text/html" = "firefox.desktop";

    # Firefox profiles
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        # Extensions (automatically installed) - Updated to new syntax
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin # Ad blocker
          bitwarden # Password manager
          privacy-badger # Privacy protection
          clearurls # Remove tracking parameters
          decentraleyes # CDN protection
          firefox-color # Theme customization
          darkreader # Dark mode for websites
          tree-style-tab # Vertical tabs
          multi-account-containers # Container tabs
          tabliss # New tab page
          # reddit-enhancement-suite
          # ghostery
          # metamask
        ];

        # Search engines - Updated to use IDs instead of names
        search = {
          force = true;
          default = "google";
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };

            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              icon = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };

            "GitHub" = {
              urls = [{template = "https://github.com/search?q={searchTerms}";}];
              icon = "https://github.com/favicon.ico";
              definedAliases = ["@gh"];
            };

            "YouTube" = {
              urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
              icon = "https://www.youtube.com/favicon.ico";
              definedAliases = ["@yt"];
            };
          };
        };

        # Bookmarks - Updated to new syntax with force option
        bookmarks = {
          force = true;
          settings = [
            {
              name = "Development";
              toolbar = true;
              bookmarks = [
                {
                  name = "NixOS Manual";
                  url = "https://nixos.org/manual/nixos/stable/";
                }
                {
                  name = "Home Manager Options";
                  url = "https://mipmip.github.io/home-manager-option-search/";
                }
                {
                  name = "GitHub";
                  url = "https://github.com/";
                }
              ];
            }
            {
              name = "Tech News";
              toolbar = true;
              bookmarks = [
                {
                  name = "Hacker News";
                  url = "https://news.ycombinator.com/";
                }
                {
                  name = "Reddit Programming";
                  url = "https://www.reddit.com/r/programming/";
                }
              ];
            }
          ];
        };

        # Firefox settings/preferences
        settings = {
          # Privacy & Security
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;

          # Disable telemetry
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.server" = "data:,";

          # Disable pocket
          "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "extensions.pocket.enabled" = false;

          # Performance
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "widget.dmabuf.force-enabled" = true; # Wayland performance

          # UI customization
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.uidensity" = 1; # Compact UI
          "browser.tabs.tabmanager.enabled" = false;

          # Download behavior
          "browser.download.useDownloadDir" = false; # Always ask where to save
          "browser.download.always_ask_before_handling_new_types" = true;

          # New tab page
          "browser.newtabpage.enabled" = true;
          "browser.startup.homepage" = "about:home";

          # Font settings
          "font.name.serif.x-western" = "DejaVu Serif";
          "font.name.sans-serif.x-western" = "DejaVu Sans";
          "font.name.monospace.x-western" = "JetBrains Mono";

          # Dark theme preference
          "layout.css.prefers-color-scheme.content-override" = 0; # Follow system theme
        };

        # User Chrome CSS (custom Firefox UI styling)
        userChrome = ''
          /* Hide tab bar when using Tree Style Tab */
          #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
            opacity: 0;
            pointer-events: none;
          }
          #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
              visibility: collapse !important;
          }

          /* Compact tab spacing */
          .tabbrowser-tab {
            min-height: 28px !important;
          }

          /* Hide sidebar header for Tree Style Tab */
          #sidebar-header {
            display: none;
          }
        '';

        # User Content CSS (custom webpage styling)
        userContent = ''
          /* Dark scrollbars */
          * {
            scrollbar-width: thin;
            scrollbar-color: #4a4a4a #2a2a2a;
          }
        '';
      };

      # Example: Work profile with different settings
      work = {
        id = 1;
        name = "work";
        isDefault = false;

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          multi-account-containers
        ];

        settings = {
          # More restrictive privacy settings for work
          "privacy.resistFingerprinting" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.sessions" = true;
        };
      };
    };

    # Firefox policies (enterprise-style configuration)
    policies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      FirefoxHome = {
        Search = true;
        Snippets = false;
        TopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredTopSites = false;
        SponsoredPocket = false;
      };
    };
  };

  # Install Firefox extensions repository (NUR)
  # Add this to your flake.nix or configuration.nix:
  # nixpkgs.config.packageOverrides = pkgs: {
  #   nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #     inherit pkgs;
  #   };
  # };
})
