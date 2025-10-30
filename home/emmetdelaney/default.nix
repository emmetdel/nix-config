{ config, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
    # ./hyprland.nix  # Disabled in favor of omarchy-nix's hyprland configuration
    inputs.omarchy-nix.homeManagerModules.default
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "emmetdelaney";
  home.homeDirectory = "/home/emmetdelaney";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}