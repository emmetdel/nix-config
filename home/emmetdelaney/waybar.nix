{
  config,
  pkgs,
  ...
}: {
  # Waybar configuration with Tokyo Night theme
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 4;

        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "cpu" "memory" "temperature" "disk" "battery" "tray"];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 50;
          separate-outputs = true;
        };

        "clock" = {
          format = " {:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = " {:%d/%m}";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        "network" = {
          format-wifi = " {signalStrength}%";
          format-ethernet = "󰈀 {ifname}";
          format-disconnected = "󰖪";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{timeTo}";
        };

        "tray" = {
          spacing = 10;
        };

        "cpu" = {
          format = "󰻠 {usage}%";
          tooltip = false;
          on-click = "kitty htop";
        };

        "memory" = {
          format = " {percentage}%";
          tooltip = false;
          on-click = "kitty htop";
        };

        "temperature" = {
          format = "{temperatureC}°C";
          format-icons = [""];
          tooltip = false;
        };

        "disk" = {
          format = " {percentage_used}%";
          path = "/";
          tooltip = false;
          on-click = "kitty df -h";
        };
      };
    };

    style = ''
      * {
        font-family: "Inter";
        font-size: 16px;
      }

      window#waybar {
        background-color: #1a1b26;
        border-bottom: 3px solid #7aa2f7;
        color: #c0caf5;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #c0caf5;
        border-radius: 0;
      }

      #workspaces button.active {
        background-color: #7aa2f7;
        color: #1a1b26;
      }

      #workspaces button:hover {
        background-color: #292e42;
        color: #c0caf5;
      }

      #clock, #battery, #cpu, #memory, #temperature, #disk, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin-bottom: 3px;
        background-color: #1a1b26;
        color: #c0caf5;
      }

      #battery.warning {
        color: #e0af68;
      }

      #battery.critical {
        color: #f7768e;
      }

      #network.disconnected {
        color: #f7768e;
      }

      #pulseaudio.muted {
        color: #f7768e;
      }
    '';
  };
}
