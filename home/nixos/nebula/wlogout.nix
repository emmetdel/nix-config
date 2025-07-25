({
  config,
  pkgs,
  ...
}: {
  # Install wlogout configuration
  home.file.".config/wlogout/style.css" = {
    text = ''
      * {
        background: transparent;
        border: 0;
        border-radius: 0;
        color: #cdd6f4;
        font-family: "JetBrains Mono", monospace;
        font-size: 14px;
        font-weight: bold;
        min-height: 0;
      }

      window {
        background: rgba(30, 30, 46, 0.95);
        border: 2px solid rgba(137, 180, 250, 0.3);
        border-radius: 15px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
      }

      #outer-box {
        margin: 20px;
        padding: 20px;
      }

      #inner-box {
        margin: 10px;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #input {
        margin: 0px;
        border: none;
        background: rgba(49, 50, 68, 0.8);
        border-radius: 10px;
        padding: 10px;
      }

      #input image {
        color: #cdd6f4;
      }

      #input:focus {
        border: 2px solid rgba(137, 180, 250, 0.5);
      }

      #text {
        margin: 0px;
        border: none;
        color: #cdd6f4;
      }

      #text:selected {
        color: #181825;
      }

      #entry {
        margin: 5px;
        border: none;
        border-radius: 10px;
        background: rgba(49, 50, 68, 0.8);
        padding: 10px;
        transition: all 0.3s ease;
      }

      #entry:selected {
        background: linear-gradient(135deg, #89b4fa, #74c7ec);
        color: #181825;
        font-weight: bold;
        box-shadow: 0 2px 8px rgba(137, 180, 250, 0.4);
      }

      #entry:hover {
        background: rgba(137, 180, 250, 0.15);
        color: #cdd6f4;
      }

      #entry:selected #text {
        color: #181825;
      }

      #entry:selected #text:selected {
        color: #181825;
      }

      #img {
        margin: 0px;
        border: none;
      }

      #img:selected {
        color: #181825;
      }

      #text:selected {
        color: #181825;
      }

      #entry:selected #img {
        color: #181825;
      }

      #entry:selected #img:selected {
        color: #181825;
      }
    '';
  };

  # Install wlogout layout configuration
  home.file.".config/wlogout/layout" = {
    text = ''
      {
        "label" : "lock",
        "action" : "swaylock-effects --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 00ff00 --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --fade-in 0.1",
        "text" : "Lock",
        "keybind" : "l"
      }
      {
        "label" : "logout",
        "action" : "hyprctl dispatch exit",
        "text" : "Logout",
        "keybind" : "e"
      }
      {
        "label" : "reboot",
        "action" : "systemctl reboot",
        "text" : "Reboot",
        "keybind" : "r"
      }
      {
        "label" : "shutdown",
        "action" : "systemctl poweroff",
        "text" : "Shutdown",
        "keybind" : "s"
      }
      {
        "label" : "suspend",
        "action" : "systemctl suspend",
        "text" : "Suspend",
        "keybind" : "u"
      }
      {
        "label" : "hibernate",
        "action" : "systemctl hibernate",
        "text" : "Hibernate",
        "keybind" : "h"
      }
    '';
  };
})
