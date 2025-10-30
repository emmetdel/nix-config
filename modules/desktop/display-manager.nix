{ config, lib, pkgs, ... }:

{
  # Disable GNOME and GDM
  services.xserver.displayManager.gdm.enable = lib.mkForce false;
  services.xserver.desktopManager.gnome.enable = lib.mkForce false;

  # Enable SDDM for Hyprland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}