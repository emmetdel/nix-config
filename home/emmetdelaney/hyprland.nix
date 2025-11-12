{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./waybar.nix
    ./rofi.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    # Use the flake package for latest features
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      # Monitor configuration
      monitor = "DP-2,3440x1440@100,0x0,1.25";

      # Execute at launch
      exec-once = [
        "waybar"
        "mako"
        "nm-applet --indicator"
        "blueman-applet"
        "/nix/store/$(ls -t /nix/store/ | grep polkit-gnome | head -n1)/libexec/polkit-gnome-authentication-agent-1"
        "swaybg -c '#1a1b26'"
        "mkdir -p $HOME/.config/chromium/WebApps"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
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
        "$mod, B, exec, librewolf" # Main browser (Librewolf)
        "$mod, C, exec, code" # Editor (VSCode/Cursor)
        "$mod, F, exec, thunar" # File manager

        # Close window (Super + W)
        "$mod, W, killactive,"

        # Window management
        "$mod, Q, killactive,"
        # "$mod, M, exit,"
        "$mod SHIFT, F, togglefloating,"
        "$mod SHIFT, M, fullscreen,"

        # Application launcher
        "$mod, SPACE, exec, rofi -show drun"
        "$mod, R, exec, rofi -show run"

        # Terminal dropdown (Super + `)
        "$mod, grave, exec, [floating; size 80% 60%; center] kitty --class=dropdown"

        # Global search (Super + /)
        "$mod, slash, exec, rofi -show combi"

        # Window cycling (Super + Tab)
        "$mod, Tab, cyclenext,"
        "$mod SHIFT, Tab, cyclenext, prev"

        # Development shortcuts
        "$mod, G, exec, [floating; center] kitty --hold --title git-status -e git status" # Git status
        "$mod SHIFT, B, exec, [floating; center] kitty --hold --title build -e 'echo \"Available build commands:\" && echo \"- make\" && echo \"- npm run build\" && echo \"- go build\" && echo \"- cargo build\" && echo \"- nix-build\" && $SHELL'" # Build menu
        "$mod SHIFT, T, exec, [floating; center] kitty --hold --title test -e 'echo \"Available test commands:\" && echo \"- make test\" && echo \"- npm test\" && echo \"- go test\" && echo \"- cargo test\" && echo \"- pytest\" && $SHELL'" # Test menu
        "$mod SHIFT, S, exec, [floating; center] kitty --hold --title server -e 'echo \"Available servers:\" && echo \"- python3 -m http.server\" && echo \"- live-server\" && echo \"- npm start\" && echo \"- go run main.go\" && $SHELL'" # Development server menu

        # Utilities
        "$mod, L, exec, swaylock" # Lock screen
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy" # Screenshot area
        "SHIFT, Print, exec, grim - | wl-copy" # Screenshot full screen

        # Media keys
        ", XF86AudioRaiseVolume, exec, pamixer -i 5 && notify-send -a \"volume\" -r 999 \"Volume: $(pamixer --get-volume)%\" -t 1000"
        ", XF86AudioLowerVolume, exec, pamixer -d 5 && notify-send -a \"volume\" -r 999 \"Volume: $(pamixer --get-volume)%\" -t 1000"
        ", XF86AudioMute, exec, pamixer -t && (pamixer --get-mute | grep -q true && notify-send -a \"volume\" -r 999 \"Volume: Muted\" -t 1000 || notify-send -a \"volume\" -r 999 \"Volume: $(pamixer --get-volume)%\" -t 1000)"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

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

        # Move windows to sides
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

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
        "workspace 3, class:^(librewolf|Librewolf)$"

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

        # Terminal dropdown
        "float, class:^(dropdown)$"
        "center, class:^(dropdown)$"
        "size 80% 60%, class:^(dropdown)$"
      ];
    };
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
      font = "Inter 14";
      padding = "10";
    };
  };

  # Swaylock configuration with Tokyo Night theme
  programs.swaylock = {
    enable = true;
    settings = {
      color = "1a1b26";
      font-size = 28;
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

  # Volume control script with notifications
  home.file.".config/hypr/scripts/volume.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      case $1 in
        up)
          pamixer -i 5
          ;;
        down)
          pamixer -d 5
          ;;
        mute)
          pamixer -t
          ;;
      esac

      volume=$(pamixer --get-volume)
      muted=$(pamixer --get-mute)

      if [ "$muted" = "true" ]; then
        notify-send "Volume: Muted" -t 1000
      else
        notify-send "Volume: $volume%" -t 1000
      fi
    '';
  };
}
