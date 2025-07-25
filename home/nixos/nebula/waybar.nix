({
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 4;
        margin-top = 8;
        margin-bottom = 0;
        margin-left = 12;
        margin-right = 12;

        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-center = ["hyprland/window"];
        modules-right = ["idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "clock" "tray" "custom/powermenu"];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{icon}";
          format-icons = {
            "1" = "●"; # Terminal
            "2" = "●"; # Browser
            "3" = "●"; # Files
            "4" = "●"; # Video
            "5" = "●"; # Chat
            "6" = "●"; # Games
            "7" = "●"; # Documents
            "8" = "●"; # Music
            "9" = "●"; # Settings
            "10" = "●"; # Misc
            urgent = "!";
            focused = "◉";
            default = "○";
          };
          persistent-workspaces = {
            "*" = 5; # 5 workspaces by default on every monitor
          };
        };

        "hyprland/submap" = {
          format = "⌨️ {}";
          max-length = 8;
          tooltip = false;
        };

        "hyprland/window" = {
          format = "🪟 {}";
          separate-outputs = true;
          max-length = 60;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "☕";
            deactivated = "💤";
          };
        };

        clock = {
          timezone = "Europe/Dublin";
          format = "🕐 {:%H:%M}";
          format-alt = "📅 {:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        cpu = {
          format = "💻 {usage}%";
          tooltip = false;
          interval = 1;
          on-click = "kitty -e htop";
        };

        memory = {
          format = "🧠 {}%";
          tooltip-format = "Memory: {used:0.1f}G/{total:0.1f}G";
          interval = 1;
          on-click = "kitty -e htop";
        };

        temperature = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "🔥 {temperatureC}°C";
          format = "🌡️ {temperatureC}°C";
        };

        network = {
          format-wifi = "📶 {signalStrength}%";
          format-ethernet = "🌐 {bandwidthDownBits}";
          tooltip-format = "🌐 {ifname} via {gwaddr}";
          format-linked = "🔗 {ifname} (No IP)";
          format-disconnected = "❌ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          interval = 5;
          on-click-right = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "🎧 {volume}% {icon}";
          format-bluetooth-muted = "🔇 {icon}";
          format-muted = "🔇";
          format-icons = {
            headphone = "🎧";
            hands-free = "🎤";
            headset = "🎧";
            phone = "📱";
            portable = "📻";
            car = "🚗";
            default = ["🔈" "🔉" "🔊"];
          };
          tooltip-format = "{desc}, {volume}%";
          on-click = "pavucontrol";
          on-click-right = "pamixer -t";
          on-scroll-up = "pamixer -i 1";
          on-scroll-down = "pamixer -d 1";
          scroll-step = 1;
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "🔌 {capacity}%";
          format-plugged = "🔌 {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["🪫" "🔋" "🔋" "🔋" "🔋"];
          tooltip-format = "{timeTo}, {capacity}%";
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };

        "custom/powermenu" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono", monospace;
        font-size: 14px;
        font-weight: bold;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.85);
        border: 2px solid rgba(137, 180, 250, 0.3);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.5s;
        border-radius: 15px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
      }

      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 8px;
        transition: all 0.3s ease;
      }

      button:hover {
        background: rgba(137, 180, 250, 0.2);
        box-shadow: inset 0 -3px rgba(137, 180, 250, 0.5);
      }

      #workspaces {
        background: rgba(49, 50, 68, 0.8);
        border-radius: 10px;
        margin: 4px;
        padding: 2px 6px;
      }

      #workspaces button {
        padding: 4px 8px;
        margin: 0 2px;
        background-color: transparent;
        color: #7f849c;
        border-radius: 6px;
        transition: all 0.3s ease;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.15);
        color: #cdd6f4;
      }

      #workspaces button.active {
        background: linear-gradient(135deg, #89b4fa, #74c7ec);
        color: #181825;
        font-weight: bold;
        box-shadow: 0 2px 8px rgba(137, 180, 250, 0.4);
      }

      #workspaces button.urgent {
        background: linear-gradient(135deg, #f38ba8, #fab387);
        color: #181825;
        animation: blink 1s ease-in-out infinite alternate;
      }

      #submap {
        background: linear-gradient(135deg, #a6e3a1, #94e2d5);
        color: #181825;
        padding: 4px 12px;
        margin: 4px;
        border-radius: 10px;
        font-weight: bold;
      }

      #window {
        background: rgba(49, 50, 68, 0.8);
        padding: 4px 16px;
        margin: 4px;
        border-radius: 10px;
        color: #cdd6f4;
      }

      #idle_inhibitor {
        background: rgba(49, 50, 68, 0.8);
        padding: 4px 8px;
        margin: 2px;
        border-radius: 8px;
        color: #f9e2af;
      }

      #idle_inhibitor.activated {
        background: linear-gradient(135deg, #f9e2af, #fab387);
        color: #181825;
      }

      #clock {
        background: linear-gradient(135deg, #89b4fa, #74c7ec);
        color: #181825;
        padding: 4px 12px;
        margin: 2px;
        border-radius: 10px;
        font-weight: bold;
      }

      #battery {
        background: linear-gradient(135deg, #a6e3a1, #94e2d5);
        color: #181825;
        padding: 4px 12px;
        margin: 2px;
        border-radius: 10px;
        font-weight: bold;
      }

      #battery.charging {
        background: linear-gradient(135deg, #f9e2af, #fab387);
      }

      #battery.warning:not(.charging) {
        background: linear-gradient(135deg, #fab387, #f38ba8);
        animation: blink 0.5s linear infinite alternate;
      }

      #battery.critical:not(.charging) {
        background: linear-gradient(135deg, #f38ba8, #eba0ac);
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to {
          background: rgba(243, 139, 168, 0.5);
        }
      }

      #cpu {
        background: linear-gradient(135deg, #a6e3a1, #94e2d5);
        color: #181825;
        padding: 4px 12px;
        margin: 2px;
        border-radius: 10px;
        font-weight: bold;
      }

      #memory {
        background: linear-gradient(135deg, #cba6f7, #b4befe);
        color: #181825;
        padding: 4px 12px;
        margin: 2px;
        border-radius: 10px;
        font-weight: bold;
      }

      #temperature {
        background: linear-gradient(135deg, #fab387, #f9e2af);
        color: #181825;
        padding: 4px 12px;
        margin: 2px;
        border-radius: 10px;
        font-weight: bold;
      }

      #temperature.critical {
        background: linear-gradient(135deg, #f38ba8, #eba0ac);
        animation: blink 0.5s linear infinite alternate;
      }

      #network {
        background: linear-gradient(135deg, #89b4fa, #74c7ec);
        color: #181825;
        padding: 4px 12px;
        margin: 2px;
        border-radius: 10px;
        font-weight: bold;
      }

      #network.disconnected {
        background: linear-gradient(135deg, #f38ba8, #eba0ac);
      }

      #pulseaudio {
        background: linear-gradient(135deg, #f9e2af, #fab387);
        color: #181825;
        padding: 4px 12px;
        margin: 2px;
        border-radius: 10px;
        font-weight: bold;
      }

      #pulseaudio.muted {
        background: rgba(127, 132, 156, 0.8);
        color: #cdd6f4;
      }

      #tray {
        background: rgba(49, 50, 68, 0.8);
        padding: 4px 8px;
        margin: 2px 4px;
        border-radius: 10px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f38ba8;
        border-radius: 6px;
      }

      #custom-powermenu {
        background: linear-gradient(135deg, #f38ba8, #eba0ac);
        color: #181825;
        padding: 4px 12px;
        margin: 2px;
        border-radius: 10px;
        font-weight: bold;
        transition: all 0.3s ease;
      }

      #custom-powermenu:hover {
        background: linear-gradient(135deg, #eba0ac, #f38ba8);
        transform: scale(1.05);
      }

      tooltip {
        background: rgba(30, 30, 46, 0.95);
        border: 1px solid rgba(137, 180, 250, 0.3);
        border-radius: 8px;
        color: #cdd6f4;
      }

      tooltip label {
        color: #cdd6f4;
      }
    '';
  };
})
