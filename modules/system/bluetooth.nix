{ config, lib, pkgs, ... }:

{
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Enable Bluetooth manager
  services.blueman.enable = true;

  # Add user to bluetooth group
  users.users.emmetdelaney.extraGroups = [ "bluetooth" ];
}