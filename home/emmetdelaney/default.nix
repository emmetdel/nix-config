{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix      # Minimal package list
    ./hyprland.nix      # Hyprland with Tokyo Night theme
    ./shell.nix         # Shell configuration
    ./web-apps.nix      # PWA web apps support
  ];

  # Home Manager settings
  home.username = "emmetdelaney";
  home.homeDirectory = "/home/emmetdelaney";
  home.stateVersion = "25.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Basic neovim as minimal editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # GTK theme (minimal)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Qt theme
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # Cursor theme
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}