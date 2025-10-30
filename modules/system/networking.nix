{ config, lib, pkgs, ... }:

{
  # Network configuration
  networking.hostName = "helios";
  networking.networkmanager.enable = true;

  # Enable experimental features for flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # User groups for networking
  users.users.emmetdelaney.extraGroups = [ "networkmanager" ];
}