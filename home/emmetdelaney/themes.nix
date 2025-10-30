{ config, pkgs, lib, ... }:

let
  # Define available themes
  themes = {
    tokyo-night = {
      name = "Tokyo Night";
      colors = {
        bg = "#1a1b26";
        bg-alt = "#16161e";
        bg-highlight = "#292e42";
        fg = "#c0caf5";
        fg-alt = "#a9b1d6";
        fg-dim = "#565f89";
        
        black = "#15161e";
        red = "#f7768e";
        green = "#9ece6a";
        yellow = "#e0af68";
        blue = "#7aa2f7";
        magenta = "#bb9af7";
        cyan = "#7dcfff";
        white = "#c0caf5";
        
        bright-black = "#414868";
        bright-red = "#f7768e";
        bright-green = "#9ece6a";
        bright-yellow = "#e0af68";
        bright-blue = "#7aa2f7";
        bright-magenta = "#bb9af7";
        bright-cyan = "#7dcfff";
        bright-white = "#c0caf5";
        
        border = "#7aa2f7";
        border-inactive = "#565f89";
      };
    };
    
    catppuccin-mocha = {
      name = "Catppuccin Mocha";
      colors = {
        bg = "#1e1e2e";
        bg-alt = "#181825";
        bg-highlight = "#313244";
        fg = "#cdd6f4";
        fg-alt = "#bac2de";
        fg-dim = "#6c7086";
        
        black = "#45475a";
        red = "#f38ba8";
        green = "#a6e3a1";
        yellow = "#f9e2af";
        blue = "#89b4fa";
        magenta = "#f5c2e7";
        cyan = "#94e2d5";
        white = "#bac2de";
        
        bright-black = "#585b70";
        bright-red = "#f38ba8";
        bright-green = "#a6e3a1";
        bright-yellow = "#f9e2af";
        bright-blue = "#89b4fa";
        bright-magenta = "#f5c2e7";
        bright-cyan = "#94e2d5";
        bright-white = "#a6adc8";
        
        border = "#89b4fa";
        border-inactive = "#6c7086";
      };
    };
    
    nord = {
      name = "Nord";
      colors = {
        bg = "#2e3440";
        bg-alt = "#242933";
        bg-highlight = "#3b4252";
        fg = "#d8dee9";
        fg-alt = "#e5e9f0";
        fg-dim = "#4c566a";
        
        black = "#3b4252";
        red = "#bf616a";
        green = "#a3be8c";
        yellow = "#ebcb8b";
        blue = "#81a1c1";
        magenta = "#b48ead";
        cyan = "#88c0d0";
        white = "#e5e9f0";
        
        bright-black = "#4c566a";
        bright-red = "#bf616a";
        bright-green = "#a3be8c";
        bright-yellow = "#ebcb8b";
        bright-blue = "#81a1c1";
        bright-magenta = "#b48ead";
        bright-cyan = "#8fbcbb";
        bright-white = "#eceff4";
        
        border = "#88c0d0";
        border-inactive = "#4c566a";
      };
    };
    
    gruvbox = {
      name = "Gruvbox Dark";
      colors = {
        bg = "#282828";
        bg-alt = "#1d2021";
        bg-highlight = "#3c3836";
        fg = "#ebdbb2";
        fg-alt = "#d5c4a1";
        fg-dim = "#504945";
        
        black = "#282828";
        red = "#cc241d";
        green = "#98971a";
        yellow = "#d79921";
        blue = "#458588";
        magenta = "#b16286";
        cyan = "#689d6a";
        white = "#a89984";
        
        bright-black = "#928374";
        bright-red = "#fb4934";
        bright-green = "#b8bb26";
        bright-yellow = "#fabd2f";
        bright-blue = "#83a598";
        bright-magenta = "#d3869b";
        bright-cyan = "#8ec07c";
        bright-white = "#ebdbb2";
        
        border = "#83a598";
        border-inactive = "#504945";
      };
    };
  };
  
  # Select the active theme (change this to switch themes)
  activeTheme = themes.tokyo-night;
  colors = activeTheme.colors;
in
{
  # GTK theming
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
    font = {
      name = "Inter";
      size = 11;
    };
  };
  
  # Qt theming
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
  
  # Kitty theme colors
  programs.kitty.settings = {
    foreground = colors.fg;
    background = colors.bg;
    selection_foreground = colors.bg;
    selection_background = colors.cyan;
    
    color0 = colors.black;
    color1 = colors.red;
    color2 = colors.green;
    color3 = colors.yellow;
    color4 = colors.blue;
    color5 = colors.magenta;
    color6 = colors.cyan;
    color7 = colors.white;
    
    color8 = colors.bright-black;
    color9 = colors.bright-red;
    color10 = colors.bright-green;
    color11 = colors.bright-yellow;
    color12 = colors.bright-blue;
    color13 = colors.bright-magenta;
    color14 = colors.bright-cyan;
    color15 = colors.bright-white;
    
    cursor = colors.cyan;
    cursor_text_color = colors.bg;
  };
  
  # Waybar theme
  programs.waybar.style = lib.mkForce ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 13px;
    }

    window#waybar {
      background-color: ${colors.bg};
      color: ${colors.fg};
      border-bottom: 2px solid ${colors.border};
    }

    #workspaces button {
      padding: 0 10px;
      color: ${colors.fg-alt};
      background-color: transparent;
      border: none;
    }

    #workspaces button.active {
      background-color: ${colors.bg-highlight};
      color: ${colors.blue};
      border-bottom: 2px solid ${colors.border};
    }

    #workspaces button:hover {
      background-color: ${colors.bg-highlight};
    }

    #window {
      color: ${colors.fg-alt};
      font-weight: normal;
    }

    #clock,
    #battery,
    #pulseaudio,
    #network,
    #tray {
      padding: 0 10px;
      background-color: transparent;
      color: ${colors.fg};
    }

    #battery.charging {
      color: ${colors.green};
    }

    #battery.warning {
      color: ${colors.yellow};
    }

    #battery.critical {
      color: ${colors.red};
    }

    #pulseaudio.muted {
      color: ${colors.fg-dim};
    }

    #network.disconnected {
      color: ${colors.red};
    }
  '';
  
  # Mako theme
  services.mako.settings = {
    default-timeout = 5000;
    background-color = colors.bg;
    text-color = colors.fg;
    border-color = colors.border;
    border-size = 2;
    border-radius = 10;
    padding = 10;
    font = "JetBrainsMono Nerd Font 11";
  };
  
  # Rofi theme
  programs.rofi = {
    enable = true;
    theme = "~/.config/rofi/theme.rasi";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "  Apps ";
      display-run = "  Run ";
      display-window = " 﩯 Window";
      sidebar-mode = true;
    };
  };
  
  # Rofi theme file
  home.file.".config/rofi/theme.rasi".text = ''
    * {
      bg: ${colors.bg};
      bg-alt: ${colors.bg-alt};
      bg-selected: ${colors.bg-highlight};
      
      fg: ${colors.fg};
      fg-alt: ${colors.fg-alt};
      
      border: ${colors.border};
      
      background-color: @bg;
      text-color: @fg;
    }

    window {
      transparency: "real";
      background-color: @bg;
      border: 2px;
      border-color: @border;
      border-radius: 10px;
      width: 600px;
      padding: 20px;
    }

    mainbox {
      background-color: transparent;
      children: [inputbar, listview];
      spacing: 20px;
    }

    inputbar {
      background-color: @bg-alt;
      border-radius: 8px;
      padding: 10px;
      children: [prompt, entry];
    }

    prompt {
      background-color: transparent;
      text-color: @border;
      padding: 0 10px 0 0;
    }

    entry {
      background-color: transparent;
      placeholder: "Search...";
      placeholder-color: @fg-alt;
    }

    listview {
      background-color: transparent;
      lines: 8;
      scrollbar: false;
    }

    element {
      background-color: transparent;
      padding: 8px;
      border-radius: 6px;
    }

    element selected {
      background-color: @bg-selected;
      text-color: @border;
    }

    element-icon {
      size: 24px;
      padding: 0 10px 0 0;
    }

    element-text {
      background-color: transparent;
      text-color: inherit;
    }
  '';
  
  # Hyprland colors (these will be imported in hyprland.nix)
  home.sessionVariables = {
    THEME_BG = colors.bg;
    THEME_FG = colors.fg;
    THEME_BORDER = colors.border;
    THEME_BORDER_INACTIVE = colors.border-inactive;
  };
}

