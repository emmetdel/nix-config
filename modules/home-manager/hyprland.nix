{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprland;
in {
  options.hyprland = {
    enable = mkEnableOption "Enable Hyprland configuration";
    terminal = mkOption {
      type = types.str;
      default = "kitty";
      description = "Default terminal emulator";
    };
    menu = mkOption {
      type = types.str;
      default = "wofi --show drun";
      description = "Application launcher command";
    };
    fileManager = mkOption {
      type = types.str;
      default = "thunar";
      description = "Default file manager";
    };
    browser = mkOption {
      type = types.str;
      default = "firefox";
      description = "Default web browser";
    };
    editor = mkOption {
      type = types.str;
      default = "code";
      description = "Default text editor";
    };
  };

  config = mkIf cfg.enable {
    # Essential packages for Hyprland
    home.packages = with pkgs; [
      # Core Hyprland functionality
      hyprland
      # Status bar
      waybar
      # Application launcher
      wofi
      # Basic utilities
      wl-clipboard
      # Additional utilities for better wofi experience
      xdg-utils # For proper application launching
      desktop-file-utils # For .desktop file handling
      # Audio control
      pavucontrol
      pulseaudio
      # Network management
      networkmanagerapplet
      # Power/logout menu
      wlogout
      # Wallpaper management
      swww
      # Notifications
      libnotify
      # Font for icons
      nerdfonts
      font-awesome
    ];

    # Minimal Hyprland configuration
    xdg.configFile."hypr/hyprland.conf".text = ''
      # Monitor configuration
      monitor = ,preferred,auto,auto

      # Execute apps at launch
      exec-once = waybar
      exec-once = swww-daemon
      exec-once = ~/.config/hypr/scripts/restore-wallpaper.sh

      # Set programs that you use
      $terminal = ${cfg.terminal}
      $menu = ${cfg.menu}
      $fileManager = ${cfg.fileManager}
      $browser = ${cfg.browser}
      $editor = ${cfg.editor}

      # Basic environment variables
      env = XCURSOR_SIZE,24
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland

      # Input configuration
      input {
          kb_layout = us
          follow_mouse = 1
          touchpad {
              natural_scroll = yes
          }
          sensitivity = 0
      }

      # General appearance
      general {
          gaps_in = 5
          gaps_out = 10
          border_size = 2
          col.active_border = rgba(33ccffee)
          col.inactive_border = rgba(595959aa)
          layout = dwindle
      }

      # Key bindings
      $mainMod = SUPER

      # Essential binds
      bind = $mainMod, RETURN, exec, $terminal
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, B, exec, $browser
      bind = $mainMod, C, exec, $editor
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, F, fullscreen,
      bind = $mainMod, W, exec, ~/.config/hypr/scripts/wallpaper-selector.sh

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # move window to top/bottom/left/right
      bind = $mainMod, H, movewindow, l
      bind = $mainMod, J, movewindow, d
      bind = $mainMod, K, movewindow, u
      bind = $mainMod, L, movewindow, r

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';

    # Wallpaper selector script
    xdg.configFile."hypr/scripts/wallpaper-selector.sh" = {
      text = ''
        #!/usr/bin/env bash

        # Wallpaper directory
        WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

        # Create wallpaper directory if it doesn't exist
        mkdir -p "$WALLPAPER_DIR"

        # Check if directory has wallpapers
        if [ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
          notify-send "Wallpaper Selector" "No wallpapers found in $WALLPAPER_DIR" -i dialog-information
          exit 1
        fi

        # Use wofi to select wallpaper
        selected=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -exec basename {} \; | sort | wofi --dmenu --prompt "Select Wallpaper:")

        if [ -n "$selected" ]; then
          wallpaper_path="$WALLPAPER_DIR/$selected"
          swww img "$wallpaper_path" --transition-type wipe --transition-duration 1
          notify-send "Wallpaper Changed" "Set to: $selected" -i dialog-information

          # Save current wallpaper for restoration
          echo "$wallpaper_path" > "$HOME/.config/hypr/current_wallpaper"
        fi
      '';
      executable = true;
    };

    # Wallpaper restoration script
    xdg.configFile."hypr/scripts/restore-wallpaper.sh" = {
      text = ''
        #!/usr/bin/env bash

        CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper"

        if [ -f "$CURRENT_WALLPAPER" ]; then
          wallpaper_path=$(cat "$CURRENT_WALLPAPER")
          if [ -f "$wallpaper_path" ]; then
            swww img "$wallpaper_path" --transition-type fade --transition-duration 1
          fi
        fi
      '';
      executable = true;
    };

    # Wofi configuration
    xdg.configFile."wofi/config".text = ''
      width=600
      height=400
      location=center
      show=drun
      prompt=Search...
      filter_rate=100
      allow_markup=true
      no_actions=true
      halign=fill
      orientation=vertical
      content_halign=fill
      insensitive=true
      allow_images=true
      image_size=40
      gtk_dark=true
    '';

    xdg.configFile."wofi/style.css".text = ''
      window {
        margin: 0px;
        border: 1px solid #33ccff;
        background-color: rgba(43, 48, 59, 0.9);
        border-radius: 10px;
      }

      #input {
        margin: 5px;
        border: none;
        color: #ffffff;
        background-color: rgba(100, 113, 150, 0.3);
        border-radius: 5px;
        padding: 10px;
        font-size: 14px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #ffffff;
        font-size: 13px;
      }

      #entry {
        background-color: transparent;
        border-radius: 5px;
        margin: 2px;
        padding: 8px;
      }

      #entry:selected {
        background-color: rgba(51, 204, 255, 0.3);
        border: 1px solid #33ccff;
      }

      #text:selected {
        color: #ffffff;
      }
    '';

    # Enhanced Waybar configuration
    xdg.configFile."waybar/config".text = ''
      {
        "layer": "top",
        "position": "top",
        "height": 40,
        "spacing": 4,
        "margin-top": 8,
        "margin-left": 12,
        "margin-right": 12,
        "modules-left": ["hyprland/workspaces"],
        "modules-center": ["hyprland/window"],
        "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "custom/wallpaper", "clock", "custom/power", "tray"],

        "hyprland/workspaces": {
          "disable-scroll": true,
          "all-outputs": true,
          "format": "{name}",
          "persistent-workspaces": {
            "1": [],
            "2": [],
            "3": [],
            "4": [],
            "5": []
          }
        },

        "hyprland/window": {
          "format": "{}",
          "max-length": 50,
          "separate-outputs": true
        },

        "clock": {
          "format": " {:%H:%M}",
          "format-alt": " {:%A, %B %d, %Y}",
          "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
        },

        "cpu": {
          "format": "󰍛 {usage}%",
          "interval": 2,
          "tooltip": true
        },

        "memory": {
          "format": "󰾆 {percentage}%",
          "interval": 2,
          "tooltip": true
        },

        "network": {
          "format-wifi": "󰤨 {essid}",
          "format-ethernet": "󰈀 Connected",
          "format-linked": "󰈀 {ifname} (No IP)",
          "format-disconnected": "󰤭 Disconnected",
          "format-alt": "{ifname}: {ipaddr}/{cidr}",
          "tooltip-format": "{ifname} via {gwaddr}",
          "tooltip-format-wifi": "{essid} ({signalStrength}%)",
          "tooltip-format-ethernet": "{ifname}",
          "tooltip-format-disconnected": "Disconnected"
        },

        "pulseaudio": {
          "format": "{icon} {volume}%",
          "format-muted": "󰖁 {volume}%",
          "format-icons": {
            "headphone": "󰋋",
            "hands-free": "󱡏",
            "headset": "󰋎",
            "phone": "󰏲",
            "portable": "󰦧",
            "car": "󰄋",
            "default": ["󰕿", "󰖀", "󰕾"]
          },
          "states": {
            "warning": 85
          },
          "scroll-step": 2,
          "on-click": "pavucontrol",
          "on-click-right": "pactl set-sink-mute @DEFAULT_SINK@ toggle",
          "on-scroll-up": "pactl set-sink-volume @DEFAULT_SINK@ +2%",
          "on-scroll-down": "pactl set-sink-volume @DEFAULT_SINK@ -2%",
          "tooltip": true,
          "tooltip-format": "Volume: {volume}%\nDevice: {desc}\nFormat: {format}"
        },

        "battery": {
          "states": {
            "warning": 30,
            "critical": 15
          },
          "format": "{icon} {capacity}%",
          "format-charging": "󰂄 {capacity}%",
          "format-plugged": "󰂄 {capacity}%",
          "format-alt": "{icon} {time}",
          "format-full": "󰁹 {capacity}%",
          "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
          "tooltip": true,
          "tooltip-format": "Battery: {capacity}%\nTime: {time}"
        },

        "custom/wallpaper": {
          "format": "🖼️",
          "tooltip": true,
          "tooltip-format": "Click to change wallpaper",
          "on-click": "~/.config/hypr/scripts/wallpaper-selector.sh"
        },

        "custom/power": {
          "format": "⏻",
          "tooltip": false,
          "on-click": "wlogout",
          "on-click-right": "systemctl poweroff"
        },

        "tray": {
          "icon-size": 18,
          "spacing": 8
        }
      }
    '';

    # Enhanced Waybar style
    xdg.configFile."waybar/style.css".text = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 14px;
        min-height: 0;
        font-weight: 500;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.95);
        color: #cdd6f4;
        border-radius: 0px 0px 15px 15px;
        border: 2px solid rgba(137, 180, 250, 0.3);
        border-top: none;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        margin: 0px 10px;
        padding: 0px;
      }

      /* Workspaces */
      #workspaces {
        background: rgba(49, 50, 68, 0.6);
        border-radius: 12px;
        margin: 6px 8px;
        padding: 2px 4px;
        border: 1px solid rgba(137, 180, 250, 0.2);
      }

      #workspaces button {
        padding: 6px 12px;
        margin: 2px;
        background: transparent;
        color: #a6adc8;
        border-radius: 8px;
        transition: all 0.3s ease;
        font-weight: 600;
        min-width: 20px;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.2);
        color: #89b4fa;
      }

      #workspaces button.active {
        background: #89b4fa;
        color: #1e1e2e;
        box-shadow: 0 2px 10px rgba(137, 180, 250, 0.4);
      }

      #workspaces button.urgent {
        background: #f38ba8;
        color: #1e1e2e;
      }

      /* Window title */
      #window {
        background: rgba(49, 50, 68, 0.6);
        border-radius: 12px;
        margin: 6px 8px;
        padding: 8px 16px;
        color: #cdd6f4;
        border: 1px solid rgba(137, 180, 250, 0.2);
        font-weight: 500;
      }

      /* Individual modules */
      #clock,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #battery,
      #custom-wallpaper,
      #custom-power,
      #tray {
        background: rgba(49, 50, 68, 0.8);
        margin: 0px 3px;
        padding: 8px 14px;
        border-radius: 10px;
        border: 1px solid rgba(137, 180, 250, 0.2);
        transition: all 0.3s ease;
        font-weight: 600;
      }

      #clock:hover,
      #cpu:hover,
      #memory:hover,
      #network:hover,
      #pulseaudio:hover,
      #battery:hover,
      #custom-wallpaper:hover,
      #custom-power:hover {
        background: rgba(137, 180, 250, 0.2);
      }

      #clock {
        background: #89b4fa;
        color: #1e1e2e;
        font-weight: 700;
        box-shadow: 0 2px 10px rgba(137, 180, 250, 0.3);
      }

      #cpu {
        background: #a6e3a1;
        color: #1e1e2e;
      }

      #memory {
        background: #cba6f7;
        color: #1e1e2e;
      }

      #network {
        background: #74c7ec;
        color: #1e1e2e;
      }

      #network.disconnected {
        background: #f38ba8;
        color: #1e1e2e;
      }

      #pulseaudio {
        background: #f9e2af;
        color: #1e1e2e;
      }

      #pulseaudio.muted {
        background: #6c7086;
        color: #cdd6f4;
      }

      #pulseaudio.warning {
        background: #fab387;
        color: #1e1e2e;
      }

      #battery {
        background: #94e2d5;
        color: #1e1e2e;
      }

      #battery.charging {
        background: #a6e3a1;
        color: #1e1e2e;
      }

      #battery.warning:not(.charging) {
        background: #fab387;
        color: #1e1e2e;
      }

      #battery.critical:not(.charging) {
        background: #f38ba8;
        color: #1e1e2e;
        animation: blink 1s linear infinite alternate;
      }

      @keyframes blink {
        to {
          background: #eba0ac;
        }
      }

      #custom-wallpaper {
        background: #b4befe;
        color: #1e1e2e;
        font-size: 14px;
        font-weight: 600;
        padding: 8px 12px;
      }

      #custom-wallpaper:hover {
        background: #cba6f7;
      }

      #custom-power {
        background: #f38ba8;
        color: #1e1e2e;
        font-size: 16px;
        font-weight: 700;
        padding: 8px 12px;
      }

      #custom-power:hover {
        background: #eba0ac;
      }

      #tray {
        background: rgba(49, 50, 68, 0.8);
        border-radius: 10px;
        padding: 6px 10px;
      }
    '';
  };
}
