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
    enable = mkEnableOption "Enable desktop environment";
    hyprland.enable = mkEnableOption "Enable Hyprland";
    audio.enable = mkEnableOption "Enable audio with PipeWire";
    bluetooth.enable = mkEnableOption "Enable bluetooth";
    printing.enable = mkEnableOption "Enable printing";
    autoLogin = {
      enable = mkEnableOption "Enable auto-login";
      user = mkOption {
        type = types.str;
        default = "emmet";
        description = "User to auto-login";
      };
    };
  };

  config = mkIf cfg.enable {
    # Enable Hyprland
    programs.hyprland = mkIf cfg.hyprland.enable {
      enable = true;
      xwayland.enable = true;
    };

    # Enable X server and display manager (GDM for GNOME compatibility)
    services.xserver = mkIf cfg.hyprland.enable {
      enable = true;
      # Disable unnecessary X11 services
      excludePackages = with pkgs; [xterm];

      displayManager.gdm = {
        enable = true;
        wayland = true;
        # Additional GDM configuration for faster startup
        settings = {
          daemon = {
            # Disable initial setup
            InitialSetupEnable = false;
          };
          security = {
            # Disable user list for faster login
            DisableUserList = false;
          };
        };
      };
    };

    # Enable auto-login if requested
    services.displayManager.autoLogin = mkIf (cfg.autoLogin.enable && cfg.hyprland.enable) {
      enable = true;
      user = cfg.autoLogin.user;
    };

    # Enable sound with pipewire
    security.rtkit.enable = mkIf cfg.audio.enable true;
    services.pipewire = mkIf cfg.audio.enable {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable bluetooth
    hardware.bluetooth.enable = mkIf cfg.bluetooth.enable true;
    services.blueman.enable = mkIf cfg.bluetooth.enable true;

    # Enable printing
    services.printing.enable = mkIf cfg.printing.enable true;

    # Enable polkit
    security.polkit.enable = true;

    # Enable dbus
    services.dbus.enable = true;

    # Enable xdg portal
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    };

    # Enable fonts
    fonts.packages = with pkgs; [
      jetbrains-mono
      font-awesome
      roboto
    ];

    # Add desktop packages
    environment.systemPackages = with pkgs; [
      # Hyprland ecosystem
      waybar
      dunst
      wofi
      cliphist
      swww
      hyprpaper
      hypridle
      swaylock
      # Additional desktop utilities
      libsForQt5.qt5ct
      qt6Packages.qtstyleplugin-kvantum
      # Audio
      pavucontrol
      # File management
      nautilus
      dolphin
      # System utilities
      wl-clipboard
      grim
      slurp
      grimblast
      wf-recorder
      brightnessctl
      playerctl
      # Network management
      networkmanagerapplet
      # Bluetooth
      blueman
      # Storage management
      udiskie
      # Filesystem tools
      btrfs-progs
    ];
  };
}
