{ config, lib, pkgs, ... }:

{
  # Network configuration
  networking.hostName = "helios";
  networking.networkmanager.enable = true;

  # User groups for networking
  users.users.emmetdelaney.extraGroups = [ "networkmanager" ];
}