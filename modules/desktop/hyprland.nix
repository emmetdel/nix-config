{ config, lib, pkgs, inputs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable X server (needed for some applications)
  services.xserver.enable = true;

  # XDG portal for screen sharing and file pickers
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit for authentication
  security.polkit.enable = true;

  # Essential Wayland packages
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    wayland
    xwayland
    qt5.qtwayland
    qt6.qtwayland
    
    # Screenshot and screen recording tools
    grim
    slurp
    wl-clipboard
    
    # Utilities
    wlr-randr
    
    # Notification daemon
    libnotify
  ];

  # Environment variables for Wayland
  environment.sessionVariables = {
    # Hint electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
  };
}