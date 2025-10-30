{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Original packages from configuration.nix
    code-cursor
    zed-editor
    vscode-fhs
    firefox
    
    # Terminal emulator
    kitty
    
    # File manager
    thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    
    # Application launcher
    rofi-wayland
    
    # Status bar
    waybar
    
    # Notifications
    mako
    
    # Audio control
    pavucontrol
    
    # Network management GUI
    networkmanagerapplet
    
    # Image viewer
    imv
    
    # PDF viewer
    zathura
    
    # Additional utilities
    btop
    neofetch
    
    # Screenshot tools (already in system packages, but good to have)
    grim
    slurp
    wl-clipboard
  ];

  # Firefox configuration for Wayland
  programs.firefox = {
    enable = true;
  };

  # Kitty terminal configuration
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.9";
      confirm_os_window_close = 0;
    };
  };
}