{ config, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./hyprland.nix
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

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Emmet Delaney";
        email = "emmetdel@gmail.com";
      };
    };
  };
}