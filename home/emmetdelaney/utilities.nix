{ config, pkgs, ... }:

{
  # Screen lock configuration
  programs.swaylock = {
    enable = true;
    settings = {
      color = "1a1b26";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "1a1b26";
      show-failed-attempts = true;
      image = "~/.config/wallpaper.jpg";
      scaling = "fill";
      
      # Ring colors
      ring-color = "565f89";
      ring-ver-color = "7aa2f7";
      ring-wrong-color = "f7768e";
      ring-clear-color = "e0af68";
      
      # Inside colors
      inside-color = "1a1b26";
      inside-ver-color = "1a1b26";
      inside-wrong-color = "1a1b26";
      inside-clear-color = "1a1b26";
      
      # Text colors
      text-color = "c0caf5";
      text-ver-color = "7aa2f7";
      text-wrong-color = "f7768e";
      text-clear-color = "e0af68";
    };
  };
  
  # Swayidle for automatic screen locking
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;  # 5 minutes
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 600;  # 10 minutes
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };
  
  # Clipboard history with cliphist
  services.clipman = {
    enable = false;  # We'll use cliphist instead
  };
  
  # Home file for cliphist systemd service
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  
  # File manager configurations
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        linemode = "size";
      };
    };
  };
  
  # Password manager integration (Bitwarden)
  home.packages = with pkgs; [
    # Screen locking
    swaylock-effects
    swayidle
    
    # Clipboard
    wl-clipboard
    cliphist
    
    # Screenshots and screen recording
    grim
    slurp
    swappy  # Screenshot editor
    wf-recorder  # Screen recorder
    
    # Color picker
    hyprpicker
    
    # Wallpaper
    swaybg
    
    # System info and monitoring
    fastfetch  # Modern neofetch alternative
    
    # Network tools
    networkmanagerapplet
  ];
  
  # Fastfetch configuration (modern system info)
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "logo": {
        "type": "auto",
        "padding": {
          "top": 1,
          "left": 2
        }
      },
      "display": {
        "separator": " → "
      },
      "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "display",
        "de",
        "wm",
        "terminal",
        "cpu",
        "gpu",
        "memory",
        "disk",
        "battery",
        "colors"
      ]
    }
  '';
  
  # Screenshot script
  home.file.".local/bin/screenshot".source = pkgs.writeShellScript "screenshot" ''
    #!/usr/bin/env bash
    
    case $1 in
      area)
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
        ;;
      screen)
        ${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f -
        ;;
      *)
        echo "Usage: screenshot {area|screen}"
        ;;
    esac
  '';
  
  # Clipboard history viewer script
  home.file.".local/bin/clipboard-history".source = pkgs.writeShellScript "clipboard-history" ''
    #!/usr/bin/env bash
    ${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi}/bin/rofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
  
  # Color picker script
  home.file.".local/bin/color-picker".source = pkgs.writeShellScript "color-picker" ''
    #!/usr/bin/env bash
    ${pkgs.hyprpicker}/bin/hyprpicker -a
  '';
  
  # Web apps launcher script
  home.file.".local/bin/web-apps".source = pkgs.writeShellScript "web-apps" ''
    #!/usr/bin/env bash
    
    apps=(
      "Gmail:https://gmail.com"
      "Calendar:https://calendar.google.com"
      "GitHub:https://github.com"
      "ChatGPT:https://chat.openai.com"
      "Claude:https://claude.ai"
      "Linear:https://linear.app"
      "Notion:https://notion.so"
      "Figma:https://figma.com"
    )
    
    selection=$(printf '%s\n' "''${apps[@]}" | cut -d: -f1 | ${pkgs.rofi}/bin/rofi -dmenu -p "Web App")
    
    if [ -n "$selection" ]; then
      url=$(printf '%s\n' "''${apps[@]}" | grep "^$selection:" | cut -d: -f2-)
      ${pkgs.firefox}/bin/firefox --new-window "$url"
    fi
  '';
  
  # Make scripts executable
  home.file.".local/bin/screenshot".executable = true;
  home.file.".local/bin/clipboard-history".executable = true;
  home.file.".local/bin/color-picker".executable = true;
  home.file.".local/bin/web-apps".executable = true;
  
  # Add .local/bin to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];
}

