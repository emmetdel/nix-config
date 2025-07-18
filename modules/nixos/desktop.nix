# Desktop Environment Configuration Module
# Provides Hyprland desktop environment with audio, bluetooth, and printing support
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  options.desktop = {
    enable = mkEnableOption "desktop environment configuration";

    hyprland = {
      enable = mkEnableOption "Hyprland wayland compositor";

      enableXWayland = mkOption {
        type = types.bool;
        default = true;
        description = "Enable XWayland support for legacy X11 applications";
      };
    };

    audio = {
      enable = mkEnableOption "audio support with PipeWire";

      lowLatency = mkOption {
        type = types.bool;
        default = false;
        description = "Enable low-latency audio configuration";
      };
    };

    bluetooth = {
      enable = mkEnableOption "bluetooth support";

      powerOnBoot = mkOption {
        type = types.bool;
        default = true;
        description = "Power on bluetooth adapter on boot";
      };
    };

    printing = {
      enable = mkEnableOption "printing support";

      drivers = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [hplip];
        description = "Printer drivers to install";
      };
    };

    autoLogin = {
      enable = mkEnableOption "automatic login";

      user = mkOption {
        type = types.str;
        default = "emmet";
        description = "User to automatically log in";
        example = "username";
      };
    };

    fonts = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install essential fonts";
      };

      extraFonts = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "Additional fonts to install";
        example = literalExpression "[ pkgs.nerdfonts ]";
      };
    };
  };

  config = mkIf cfg.enable {
    # Hyprland wayland compositor
    programs.hyprland = mkIf cfg.hyprland.enable {
      enable = true;
      xwayland.enable = cfg.hyprland.enableXWayland;
    };

    # Display manager and X server configuration
    services.xserver = mkIf cfg.hyprland.enable {
      enable = true;
      excludePackages = with pkgs; [xterm];

      displayManager.gdm = {
        enable = true;
        wayland = true;
        settings = {
          daemon = {
            InitialSetupEnable = false;
          };
          security = {
            DisableUserList = false;
          };
        };
      };
    };

    # Automatic login configuration
    services.displayManager.autoLogin = mkIf (cfg.autoLogin.enable && cfg.hyprland.enable) {
      enable = true;
      user = cfg.autoLogin.user;
    };

    # Audio configuration with PipeWire
    security.rtkit.enable = mkIf cfg.audio.enable true;
    services.pipewire = mkIf cfg.audio.enable {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = cfg.audio.lowLatency;

      # Low-latency configuration
      extraConfig.pipewire = mkIf cfg.audio.lowLatency {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 32;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 32;
        };
      };
    };

    # Bluetooth configuration
    hardware.bluetooth = mkIf cfg.bluetooth.enable {
      enable = true;
      powerOnBoot = cfg.bluetooth.powerOnBoot;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
    services.blueman.enable = mkIf cfg.bluetooth.enable true;

    # Printing configuration
    services.printing = mkIf cfg.printing.enable {
      enable = true;
      drivers = cfg.printing.drivers;
    };

    # Essential desktop services
    security.polkit.enable = true;
    services.dbus.enable = true;
    services.udisks2.enable = true;

    # XDG portal configuration
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    # Font configuration
    fonts = mkIf cfg.fonts.enable {
      packages = with pkgs;
        [
          # Programming fonts
          jetbrains-mono
          fira-code
          source-code-pro

          # System fonts
          roboto
          roboto-slab
          noto-fonts
          noto-fonts-emoji

          # Icon fonts
          font-awesome
          material-design-icons
        ]
        ++ cfg.fonts.extraFonts;

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = ["Roboto Slab" "Noto Serif"];
          sansSerif = ["Roboto" "Noto Sans"];
          monospace = ["JetBrains Mono" "Fira Code"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };

    # Desktop environment packages
    environment.systemPackages = with pkgs; [
      # Hyprland ecosystem
      waybar
      dunst
      wofi
      rofi-wayland
      cliphist
      swww
      hyprpaper
      hypridle
      hyprlock
      swaylock-effects

      # Wayland utilities
      wl-clipboard
      wl-clip-persist
      wtype

      # Screenshot and recording
      grim
      slurp
      grimblast
      wf-recorder

      # System control
      brightnessctl
      playerctl
      pamixer

      # File management
      nautilus
      dolphin
      thunar

      # Network management
      networkmanagerapplet

      # Audio control
      pavucontrol
      easyeffects

      # Theme and appearance
      libsForQt5.qt5ct
      qt6Packages.qtstyleplugin-kvantum
      lxappearance

      # System utilities
      udiskie
      polkit_gnome

      # Archive management
      file-roller

      # Image viewers
      imv
      feh
    ];

    # Environment variables for Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    # Polkit authentication agent
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
