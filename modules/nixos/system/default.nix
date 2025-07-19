{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dotfiles.system;
in {
  options.dotfiles.system = {
    # System configuration options
    stateVersion = mkOption {
      type = types.str;
      default = "25.05";
      description = "The NixOS state version";
    };

    # Locale and timezone options
    timeZone = mkOption {
      type = types.str;
      default = "Europe/Dublin";
      description = "The system timezone";
    };

    defaultLocale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "The system locale";
    };

    keyboardLayout = mkOption {
      type = types.str;
      default = "us";
      description = "The keyboard layout";
    };

    # Feature flags
    enableDocker = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Docker";
    };

    enableGarbageCollection = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable automatic garbage collection";
    };

    gcDays = mkOption {
      type = types.int;
      default = 30;
      description = "Number of days to keep generations before garbage collection";
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

    # Enable garbage collection if configured
    nix.gc = mkIf cfg.enableGarbageCollection {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than ${toString cfg.gcDays}d";
    };

    # Set timezone from config
    time.timeZone = cfg.timeZone;

    # Set locale from config
    i18n.defaultLocale = cfg.defaultLocale;

    # Set keyboard layout from config
    services.xserver.layout = cfg.keyboardLayout;

    # Enable Docker if configured
    virtualisation.docker.enable = cfg.enableDocker;
  };
}
