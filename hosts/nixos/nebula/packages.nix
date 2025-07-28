{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Essential tools
    wget
    curl
    git
    vim
    neovim
    htop
    btop
    tree
    unzip
    zip

    # Development tools
    nodejs_20
    python3
    rustc
    cargo
    go

    # Your requested applications
    slack
    obsidian
    kitty
    thunderbird # Email client - change if you prefer something else
    _1password-gui
    bitwarden

    # Database and development tools
    pgadmin4

    # Additional useful development tools
    docker-compose
    postman
    vscodium # Open source VSCode alternative

    # Hyprland ecosystem
    waybar # Status bar
    wofi # Application launcher
    mako # Notification daemon
    hyprlock # Screen locker for Hyprland
    swayidle # Idle management
    wlogout # Logout menu
    grim # Screenshot functionality
    slurp # Select area for screenshots
    wl-clipboard # Clipboard utilities
    brightnessctl # Brightness control
    pamixer # Audio control
    playerctl # Media control

    # Display and power management
    greetd.tuigreet # Login manager
    libinput # Input device handling
    seatd # Seat management for Wayland

    # File management and utilities
    xfce.thunar # File manager
    xfce.thunar-volman
    gvfs # Trash and mount support

    # Network and system tray
    networkmanagerapplet
    blueman # Bluetooth manager
    pavucontrol # Audio control GUI

    # Fonts and themes
    papirus-icon-theme
    qogir-icon-theme
    adwaita-icon-theme
  ];
}
