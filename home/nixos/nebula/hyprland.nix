({
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration (adjust as needed)
      monitor = ",preferred,auto,auto";

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      # Decoration
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        shadow = {
          enabled = true;
          color = "rgba(1a1a1aee)";
          range = 4;
          render_power = 3;
          offset = "0 2";
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Window rules
      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "float,class:^(blueman-manager)$"
        "float,class:^(nm-applet)$"
        "float,class:^(nm-connection-editor)$"
        "float,title:^(1Password)$"
      ];

      # Keybindings - macOS-style
      "$mainMod" = "SUPER";
      "$altMod" = "ALT";
      bind = [
        # Basic bindings (macOS-style)
        "$mainMod, Q, killactive," # Close window (like Cmd+W)
        "$mainMod, M, exit," # Quit Hyprland
        "$mainMod, SPACE, exec, wofi --show drun" # Spotlight equivalent
        "$mainMod, TAB, cyclenext," # Switch between windows
        "$mainMod SHIFT, TAB, cyclenext, prev" # Switch between windows (reverse)
        "$mainMod, RETURN, exec, kitty" # Open terminal
        "$mainMod, E, exec, thunar" # Open file manager
        "$mainMod, V, togglefloating," # Toggle floating
        "$mainMod, F, fullscreen," # Toggle fullscreen
        "$mainMod, H, movetoworkspace, -1" # Hide window (move to previous workspace)
        "$mainMod, L, exec, hyprlock" # Lock screen
        "$mainMod SHIFT, L, exec, wlogout" # Power menu

        # Window management (macOS-style)
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Window resizing (macOS-style)
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        # Window resizing with arrow keys
        "$mainMod CTRL, left, resizeactive, -20 0"
        "$mainMod CTRL, right, resizeactive, 20 0"
        "$mainMod CTRL, up, resizeactive, 0 -20"
        "$mainMod CTRL, down, resizeactive, 0 20"

        # Fine-tune resizing (smaller increments)
        "$mainMod ALT, left, resizeactive, -10 0"
        "$mainMod ALT, right, resizeactive, 10 0"
        "$mainMod ALT, up, resizeactive, 0 -10"
        "$mainMod ALT, down, resizeactive, 0 10"

        # Workspace management (macOS-style)
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        # Additional workspaces (11-20)
        "$mainMod, F1, workspace, 11"
        "$mainMod, F2, workspace, 12"
        "$mainMod, F3, workspace, 13"
        "$mainMod, F4, workspace, 14"
        "$mainMod, F5, workspace, 15"

        # Move windows to workspaces (macOS-style)
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        # Move windows to additional workspaces (11-15)
        "$mainMod SHIFT, F1, movetoworkspace, 11"
        "$mainMod SHIFT, F2, movetoworkspace, 12"
        "$mainMod SHIFT, F3, movetoworkspace, 13"
        "$mainMod SHIFT, F4, movetoworkspace, 14"
        "$mainMod SHIFT, F5, movetoworkspace, 15"

        # Mission Control equivalent (workspace overview)
        "$mainMod, D, togglespecialworkspace, magic"
        "$mainMod SHIFT, D, movetoworkspace, special:magic"

        # Screenshot bindings (macOS-style)
        "$mainMod SHIFT, 3, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png" # Full screen
        "$mainMod SHIFT, 4, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png" # Selection
        "$mainMod SHIFT, 5, exec, grim -g \"$(slurp -o)\" ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png" # Window

        # Application shortcuts (macOS-style)
        "$mainMod, B, exec, firefox" # Browser
        "$mainMod, S, exec, slack" # Slack
        "$mainMod, O, exec, obsidian" # Obsidian

        # Window layout (macOS-style)
        "$mainMod, P, pseudo," # Toggle pseudo-tiling
        "$mainMod, J, togglesplit," # Toggle split direction

        # Quick look equivalent
        "$mainMod, Y, exec, thunar --daemon" # Quick file manager
      ];

      # Mouse bindings (macOS-style)
      bindm = [
        "$mainMod, mouse:272, movewindow" # Move window with Super + left mouse
        "$mainMod, mouse:273, resizewindow" # Resize window with Super + right mouse
      ];

      # Media keys (macOS-style)
      bindel = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer --default-source -t"
        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        # macOS-style media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Auto-start applications with improved sleep handling
      exec-once = [
        "waybar"
        "mako"
        "nm-applet --indicator"
        "blueman-applet"
        "1password --silent"
        # Improved idle and sleep handling with better lock screen
        "swayidle -w timeout 300 'hyprlock' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'hyprlock' after-resume 'hyprctl dispatch dpms on'"
        # Ensure proper display handling
        "hyprctl dispatch dpms on"
        # Start wl-clipboard daemon
        "wl-paste --watch cliphist store"
      ];
    };
  };
})
