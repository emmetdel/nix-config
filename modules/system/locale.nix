{ config, lib, pkgs, ... }:

{
  # Time zone
  time.timeZone = "Europe/Dublin";

  # Locale settings
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Keyboard configuration
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Console keymap
  console.keyMap = "us";
}