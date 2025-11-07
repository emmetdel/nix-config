{
  config,
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # Use the flake package for latest features
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = {
      # Monitor configuration
      monitor = ",preferred,auto,1";

      # Execute at launch
      exec-once = [
        "waybar"
        "mako"
        "nm-applet --indicator"
        "swaybg -i ~/.config/wallpaper.jpg -m fill"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      # Input configuration
      input = {
        kb_layout = "gb";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };

      # General settings with Tokyo Night colors
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(7aa2f7) rgb(7dcfff) 45deg"; # Tokyo Night blue/cyan
        "col.inactive_border" = "rgb(565f89)"; # Tokyo Night dim
        layout = "dwindle";
        allow_tearing = false;
      };

      # Decoration with Tokyo Night shadow
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1b26ee)"; # Tokyo Night background
      };

      # Smooth animations
      animations = {
        enabled = true;
        bezier = "smooth, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, smooth"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layouts
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Misc settings
      misc = {
        force_default_wallpaper = 0;
      };

      # Keybindings - Web-First Philosophy
      "$mod" = "SUPER";

      bind = [
        # Core applications (Super + Letter)
        "$mod, Return, exec, kitty"
        "$mod, B, exec, firefox" # Browser
        "$mod, C, exec, code" # Editor (VSCode/Cursor)
        "$mod, F, exec, thunar" # File manager

        # Web Apps Launcher (Super + W)
        "$mod, W, exec, web-apps"

        # Window management
        "$mod, Q, killactive,"
        # "$mod, M, exit,"
        "$mod SHIFT, F, togglefloating,"
        "$mod SHIFT, M, fullscreen,"

        # Application launcher
        "$mod, SPACE, exec, rofi -show drun"
        "$mod, R, exec, rofi -show run"

        # Utilities
        "$mod, L, exec, swaylock" # Lock screen
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy" # Screenshot area
        "SHIFT, Print, exec, grim - | wl-copy" # Screenshot full screen

        # Move focus with vim keys
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move focus with arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces
        "$mod, 1, workspace, 1" # Communication (Gmail, Calendar)
        "$mod, 2, workspace, 2" # Development (Code, Terminal)
        "$mod, 3, workspace, 3" # Research (Firefox)
        "$mod, 4, workspace, 4" # Planning (Linear, Notion)
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Special workspace (scratchpad)
        "$mod, S, togglespecialworkspace"
        "$mod SHIFT, S, movetoworkspace, special"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Window rules for PWA auto-organization
      windowrulev2 = [
        # Communication workspace (1)
        "workspace 1, class:^(Gmail)$"
        "workspace 1, class:^(Calendar)$"

        # Development workspace (2)
        "workspace 2, class:^(code)$"
        "workspace 2, class:^(Code)$"
        "workspace 2, title:^(Visual Studio Code)$"

        # Research workspace (3)
        "workspace 3, class:^(firefox)$"

        # Planning workspace (4)
        "workspace 4, class:^(Linear)$"
        "workspace 4, class:^(Notion)$"
        "workspace 4, class:^(ChatGPT)$"

        # Float certain windows
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"

        # PWA window styling
        "size 1400 900, class:^(Gmail)$"
        "size 1400 900, class:^(Calendar)$"
        "size 1200 800, class:^(Linear)$"
        "size 1200 800, class:^(Notion)$"
        "size 1000 700, class:^(ChatGPT)$"
      ];
    };
  };

  # Waybar configuration with Tokyo Night theme
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "battery" "tray"];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        "hyprland/window" = {
          max-length = 50;
        };

        "clock" = {
          format = "{:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "🔇";
          format-icons = {
            default = ["🔈" "🔉" "🔊"];
          };
          on-click = "pavucontrol";
        };

        "network" = {
          format-wifi = "📶 {essid}";
          format-ethernet = "🌐 {ifname}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        "battery" = {
          format = "{icon} {capacity}%";
          format-icons = ["🪫" "🔋"];
          format-charging = "⚡ {capacity}%";
        };

        "tray" = {
          spacing = 10;
        };
      };
    };

    # Tokyo Night styling for Waybar
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background-color: #1a1b26;
        color: #c0caf5;
        border-bottom: 2px solid #7aa2f7;
      }

      #workspaces button {
        padding: 0 10px;
        color: #a9b1d6;
        background-color: transparent;
        border: none;
      }

      #workspaces button.active {
        background-color: #292e42;
        color: #7aa2f7;
        border-bottom: 2px solid #7aa2f7;
      }

      #workspaces button:hover {
        background-color: #292e42;
      }

      #window {
        color: #a9b1d6;
        font-weight: normal;
      }

      #clock,
      #battery,
      #pulseaudio,
      #network,
      #tray {
        padding: 0 10px;
        background-color: transparent;
        color: #c0caf5;
      }

      #battery.charging {
        color: #9ece6a;
      }

      #battery.warning {
        color: #e0af68;
      }

      #battery.critical {
        color: #f7768e;
      }

      #pulseaudio.muted {
        color: #565f89;
      }

      #network.disconnected {
        color: #f7768e;
      }
    '';
  };

  # Mako notification daemon with Tokyo Night theme
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1a1b26";
      text-color = "#c0caf5";
      border-color = "#7aa2f7";
      border-size = 2;
      border-radius = 10;
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 11";
      padding = "10";
    };
  };

  # Rofi configuration with Tokyo Night theme
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

  # Rofi theme file with Tokyo Night colors
  home.file.".config/rofi/theme.rasi".text = ''
    * {
      bg: #1a1b26;
      bg-alt: #16161e;
      bg-selected: #292e42;

      fg: #c0caf5;
      fg-alt: #a9b1d6;

      border: #7aa2f7;

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

  # Swaylock configuration with Tokyo Night theme
  programs.swaylock = {
    enable = true;
    settings = {
      color = "1a1b26";
      font-size = 24;
      indicator-radius = 100;
      line-color = "1a1b26";
      show-failed-attempts = true;

      # Ring colors (Tokyo Night)
      ring-color = "565f89";
      ring-ver-color = "7aa2f7";
      ring-wrong-color = "f7768e";

      # Inside colors
      inside-color = "1a1b26";
      inside-ver-color = "1a1b26";
      inside-wrong-color = "1a1b26";

      # Text colors
      text-color = "c0caf5";
      text-ver-color = "7aa2f7";
      text-wrong-color = "f7768e";
    };
  };
}
