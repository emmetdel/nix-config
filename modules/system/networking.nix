{ config, lib, pkgs, hostname, ... }:

{
  # Network configuration
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
}