({
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration - Optimized for Huawei MateView GT 34" (ZQE-CAA)
      # Use DisplayPort for full 165Hz, HDMI limited to 100Hz
      monitor = "DP-1,3440x1440@165,0x0,1";
      # Fallback for HDMI: "HDMI-A-1,3440x1440@100,0x0,1"

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

      # General settings - Optimized for ultrawide
      general = {
        gaps_in = 8;
        gaps_out = 16;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
        resize_on_border = true;
      };

      # Decoration - Optimized for high refresh rate and ultrawide
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          vibrancy = 0.1696;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          color = "rgba(1a1a1aee)";
          range = 12;
          render_power = 3;
          offset = "0 2";
        };
      };

      # Animations - Tuned for 165Hz performance
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 5, default, popin 80%"
          "border, 1, 8, default"
          "borderangle, 1, 6, default"
          "fade, 1, 5, default"
          "workspaces, 1, 4, default"
        ];
      };

      # Layout - Optimized for ultrawide aspect ratio
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2; # Always split to the right on ultrawide
        smart_split = true;
        smart_resizing = true;
      };

      # Master layout alternative (great for ultrawide)
      master = {
        new_status = "master";
        mfact = 0.65; # Adjusted for 21:9 aspect ratio
        orientation = "left";
        smart_resizing = true;
      };

      # Miscellaneous settings for gaming and performance
      misc = {
        vrr = 1; # Variable refresh rate for gaming
        vfr = true; # Variable frame rate
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      # Window rules - Enhanced for ultrawide productivity
      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "float,class:^(blueman-manager)$"
        "float,class:^(nm-applet)$"
        "float,class:^(nm-connection-editor)$"
        "float,title:^(1Password)$"

        # Ultrawide-specific rules
        "size 1147 1440,class:^(thunar)$,floating:1" # 1/3 width for file manager
        "center,class:^(thunar)$,floating:1"

        # Gaming optimizations
        "immediate,class:^(steam_app_).*" # Immediate mode for Steam games
        "fullscreen,class:^(steam_app_).*"

        # Browser optimizations for ultrawide
        "maxsize 2580 1440,class:^(firefox)$" # Prevent browser from being too wide
        "center,class:^(firefox)$"

        # IDE/Editor optimizations
        "maxsize 2860 1440,class:^(code)$" # VS Code optimal width
        "maxsize 2860 1440,class:^(obsidian)$"
      ];

      # Workspace rules for ultrawide organization
      workspace = [
        "1,monitor:DP-1,default:true"
        "2,monitor:DP-1"
        "3,monitor:DP-1"
        "4,monitor:DP-1"
        "5,monitor:DP-1"
        "6,monitor:DP-1"
        "7,monitor:DP-1"
        "8,monitor:DP-1"
        "9,monitor:DP-1"
        "10,monitor:DP-1"
      ];

      # Keybindings - macOS-style (kept as requested)
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

      # Auto-start applications - Enhanced for ultrawide setup
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
        # Gaming performance daemon (optional)
        # "gamemode"
      ];
    };
  };
})
