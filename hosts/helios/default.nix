{ config, lib, pkgs, inputs, userConfig, ... }:

{
  imports = [
    # Hardware configuration
    ./hardware.nix

    # System modules
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/locale.nix
    ../../modules/system/sound.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/users.nix
    # ../../modules/system/secrets.nix  # Temporarily disabled - no secrets needed yet

    # Desktop modules
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/display-manager.nix
  ];

  # User account (shell and groups configured in modules/system/users.nix)
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features for flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages (minimal, most moved to home-manager)
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    opencode
    zed-editor
    nil
  ];

  # System state version
  system.stateVersion = "25.05";
}
