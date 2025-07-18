# Basic System Configuration Module
# Provides essential system configuration including bootloader, networking, SSH, and time settings
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.basic-system;
in {
  options.basic-system = {
    enable = mkEnableOption "basic system configuration";

    hostname = mkOption {
      type = types.str;
      description = "System hostname";
      example = "apollo";
    };

    timezone = mkOption {
      type = types.str;
      default = "Europe/Dublin";
      description = "System timezone";
      example = "America/New_York";
    };

    ssh = {
      enable = mkEnableOption "SSH server";

      authorizedKeys = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "SSH authorized keys for system access";
        example = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHblA3QwMwsej6rfGbueXE3X8C3i22Q+3hGZ9MgRVk49"
        ];
      };

      port = mkOption {
        type = types.port;
        default = 22;
        description = "SSH server port";
      };
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional system packages to install";
      example = literalExpression "[ pkgs.vim pkgs.git ]";
    };

    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "System locale";
    };
  };

  config = mkIf cfg.enable {
    # System identification
    networking.hostName = cfg.hostname;

    # Locale and internationalization
    i18n.defaultLocale = cfg.locale;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.locale;
      LC_IDENTIFICATION = cfg.locale;
      LC_MEASUREMENT = cfg.locale;
      LC_MONETARY = cfg.locale;
      LC_NAME = cfg.locale;
      LC_NUMERIC = cfg.locale;
      LC_PAPER = cfg.locale;
      LC_TELEPHONE = cfg.locale;
      LC_TIME = cfg.locale;
    };

    # Bootloader configuration
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3; # Faster boot
    };

    # Time and timezone configuration
    time.timeZone = cfg.timezone;
    services.timesyncd = {
      enable = true;
      servers = [
        "time.google.com"
        "time1.google.com"
        "time2.google.com"
        "time3.google.com"
      ];
    };

    # SSH server configuration
    services.openssh = mkIf cfg.ssh.enable {
      enable = true;
      ports = [cfg.ssh.port];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        MaxAuthTries = 3;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
      };
      openFirewall = true;
    };

    # Nix configuration
    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
        trusted-users = ["root" "@wheel"];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Essential system packages
    environment.systemPackages = with pkgs;
      [
        # System monitoring
        htop
        btop

        # Network utilities
        wget
        curl

        # File utilities
        file
        tree

        # Text processing
        vim
        nano

        # Archive utilities
        unzip
        zip

        # System utilities
        lsof
        pciutils
        usbutils
      ]
      ++ cfg.packages;

    # System-wide environment variables
    environment.variables = {
      EDITOR = "vim";
      PAGER = "less";
    };
  };
}
