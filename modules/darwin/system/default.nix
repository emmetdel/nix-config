{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dotfiles.darwin;
in {
  options.dotfiles.darwin = {
    # System configuration options
    stateVersion = mkOption {
      type = types.str;
      default = "4";
      description = "The nix-darwin state version";
    };

    # Locale and timezone options
    timeZone = mkOption {
      type = types.str;
      default = "Europe/Dublin";
      description = "The system timezone";
    };

    # Feature flags
    enableAutoUpgrade = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable automatic upgrades";
    };

    enableFonts = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable system fonts";
    };
  };

  config = {
    # Core system configuration
    system.stateVersion = cfg.stateVersion;

    # Enable flakes
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Nix configuration
    nix.settings.auto-optimise-store = true;

    # Set timezone from config
    time.timeZone = cfg.timeZone;

    # Enable fonts if configured
    fonts.fontDir.enable = cfg.enableFonts;
    fonts.packages = mkIf cfg.enableFonts (with pkgs; [
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-emoji
    ]);

    # Enable auto-upgrade if configured
    system.autoUpgrade = mkIf cfg.enableAutoUpgrade {
      enable = true;
      channel = "https://nixos.org/channels/nixpkgs-unstable";
    };

    # Default system packages
    environment.systemPackages = with pkgs; [
      vim
      git
      curl
      wget
    ];

    # Default system settings
    system.defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        show-recents = false;
        static-only = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
    };
  };
}
