{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # Hardware configuration
    ./hardware.nix
    
    # System modules
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/locale.nix
    ../../modules/system/sound.nix
    ../../modules/system/users.nix
    ../../modules/system/virtualization.nix
    
    # Desktop modules
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/display-manager.nix
  ];

  # User account (shell and groups configured in modules/system/users.nix)
  users.users.emmetdelaney = {
    isNormalUser = true;
    description = "Emmet Delaney";
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages (minimal, most moved to home-manager)
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # System state version
  system.stateVersion = "25.05";
}