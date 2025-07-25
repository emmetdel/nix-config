({
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # System Configuration
  system.stateVersion = "25.05";

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;
    # Enable AMD microcode updates
    kernelModules = ["kvm-amd"];
  };

  # Networking
  networking = {
    hostName = "nebula";
    networkmanager.enable = true;
    # Enable firewall but allow common development ports
    firewall = {
      enable = true;
      allowedTCPPorts = [3000 8000 8080 5173]; # Common dev ports
    };
  };

  # Time and Locale
  time.timeZone = "Europe/Dublin"; # Adjust to your timezone
  i18n.defaultLocale = "en_IE.UTF-8"; # Adjust to your locale

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  # Hyprland Desktop Environment
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Desktop Portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # Display Manager - Improved with better styling and reliability
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland --remember --asterisks";
        user = "greeter";
      };
    };
  };

  # Improve tuigreet appearance
  environment.etc."greetd/environments".text = "Hyprland";

  # Required for Wayland
  security.polkit.enable = true;

  # Power management and sleep handling
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Screen management and sleep handling
  services = {
    # Improved power management
    upower.enable = true;

    # Better screen management
    xserver = {
      enable = true;
      displayManager.startx.enable = false;
    };
  };

  # Hardware-specific power management for AMD
  hardware = {
    # AMD power management
    graphics.enable = true;
  };

  # Systemd sleep handling
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  # Keyboard layout (can be overridden in Hyprland config)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing support
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # User Configuration
  users.users.emmetdelaney = {
    # Change "developer" to your username
    isNormalUser = true;
    description = "Development User";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd"];
    shell = pkgs.zsh;
    # Add your password hash here (replace with your own)
    hashedPassword = "$6$DQ33iq.40kbw39V.$ScAQ52zZyqIf7X211/uZ2IJjzcsnxMZZkCfBMLASqgMQtziRZeVxMUz4S04vTZuLc66Vc1OXjwU4/6mclKoml.";
  };

  # Enable ZSH system-wide
  programs.zsh.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Essential tools
    wget
    curl
    git
    vim
    neovim
    htop
    btop
    tree
    unzip
    zip

    # Development tools
    nodejs_20
    python3
    rustc
    cargo
    go

    # Your requested applications
    slack
    firefox
    obsidian
    kitty
    thunderbird # Email client - change if you prefer something else
    _1password-gui
    bitwarden

    # Database and development tools
    pgadmin4

    # Additional useful development tools
    docker-compose
    postman
    vscodium # Open source VSCode alternative

    # Hyprland ecosystem
    waybar # Status bar
    wofi # Application launcher
    mako # Notification daemon
    swaylock-effects # Enhanced screen locker with effects
    swayidle # Idle management
    wlogout # Logout menu
    grim # Screenshot functionality
    slurp # Select area for screenshots
    wl-clipboard # Clipboard utilities
    brightnessctl # Brightness control
    pamixer # Audio control
    playerctl # Media control

    # Display and power management
    greetd.tuigreet # Login manager
    libinput # Input device handling
    seatd # Seat management for Wayland

    # File management and utilities
    xfce.thunar # File manager
    xfce.thunar-volman
    gvfs # Trash and mount support

    # Network and system tray
    networkmanagerapplet
    blueman # Bluetooth manager
    pavucontrol # Audio control GUI

    # Fonts and themes
    papirus-icon-theme
    qogir-icon-theme
    adwaita-icon-theme
  ];

  # Enable Flatpak for additional app support
  services.flatpak.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable libvirtd for VMs if needed
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Fonts for development
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    jetbrains-mono
  ];

  # Enable nix flakes and new command-line tool
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimize nix store
  nix.settings.auto-optimise-store = true;

  # Allow unfree packages (needed for some proprietary software)
  nixpkgs.config.allowUnfree = true;

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.emmetdelaney = {
      # Change to your username
      home.stateVersion = "25.05";

      # Enable Wayland-specific settings
      home.sessionVariables = {
        EDITOR = "nvim";
        BROWSER = "firefox";
        TERMINAL = "kitty";
        # Wayland-specific
        NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
        MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland for Firefox
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
        # Display and sleep handling
        WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor issues
        WLR_RENDERER = "vulkan"; # Better rendering
        # Power management
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "hyprland";
      };

      # Git configuration
      programs.git = {
        enable = true;
        userName = "Emmet Delaney"; # Change this
        userEmail = "emmetdel@gmail.com"; # Change this
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
        };
      };

      # Kitty terminal configuration
      programs.kitty = {
        enable = true;
        settings = {
          font_family = "JetBrains Mono";
          font_size = 12;
          cursor_shape = "beam";
          cursor_blink_interval = 0;
          mouse_hide_wait = 2;
          select_by_word_characters = "@-./_~?&=%+#";
          remember_window_size = false;
          initial_window_width = 1200;
          initial_window_height = 800;
          tab_bar_edge = "top";
          tab_bar_style = "powerline";
          background_opacity = "0.95";
          # Wayland-specific
          wayland_titlebar_color = "system";
          linux_display_server = "wayland";
        };
      };

      # ZSH with Oh My ZSH
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          ll = "ls -l";
          la = "ls -la";
          grep = "grep --color=auto";
          nixos-rebuild = "sudo nixos-rebuild";
          nrs = "sudo nixos-rebuild switch --flake .";
          nrt = "sudo nixos-rebuild test --flake .";
          # Hyprland specific
          screenshot = "grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png";
          screenrec = "wf-recorder -g \"$(slurp)\" -f ~/Videos/recording-$(date +%Y%m%d_%H%M%S).mp4";
        };

        oh-my-zsh = {
          enable = true;
          plugins = ["git" "docker" "node" "npm" "rust" "golang"];
          theme = "robbyrussell";
        };
      };

      # Direnv for automatic environment loading
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      # Fixed Waybar configuration
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 34;
            spacing = 4;
            margin-top = 6;
            margin-bottom = 0;
            margin-left = 10;
            margin-right = 10;

            modules-left = ["hyprland/workspaces"];
            modules-center = ["hyprland/window"];
            modules-right = ["pulseaudio" "network" "cpu" "memory" "battery" "clock" "tray"];

            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              format = "{icon}";
              format-icons = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                "6" = "6";
                "7" = "7";
                "8" = "8";
                "9" = "9";
                "10" = "10";
                "11" = "11";
                "12" = "12";
                "13" = "13";
                "14" = "14";
                "15" = "15";
                urgent = "";
                focused = "";
                default = "";
              };
            };

            "hyprland/window" = {
              format = "{}";
              separate-outputs = true;
              max-length = 50;
            };

            clock = {
              timezone = "Europe/Dublin";
              format = " {:%H:%M}";
              format-alt = " {:%Y-%m-%d %H:%M:%S}";
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
              format = " {usage}%";
              tooltip = false;
              on-click = "kitty -e htop";
            };

            memory = {
              format = " {}%";
              on-click = "kitty -e htop";
            };

            network = {
              format-wifi = " {signalStrength}%";
              format-ethernet = " wired";
              tooltip-format = " {ifname} via {gwaddr}";
              format-linked = " {ifname} (No IP)";
              format-disconnected = "⚠ Disconnected";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
              on-click-right = "nm-connection-editor";
            };

            pulseaudio = {
              format = "{icon} {volume}%";
              format-bluetooth = "{volume}% {icon}";
              format-bluetooth-muted = " {icon}";
              format-muted = " ";
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = ["" "" ""];
              };
              on-click = "pavucontrol";
              on-click-right = "pamixer -t";
            };

            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = " {capacity}%";
              format-plugged = " {capacity}%";
              format-alt = "{time} {icon}";
              format-icons = ["" "" "" "" ""];
            };

            tray = {
              icon-size = 21;
              spacing = 10;
            };
          };
        };

        style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: "JetBrains Mono", monospace;
            font-size: 13px;
            min-height: 0;
          }

          window#waybar {
            background-color: rgba(43, 48, 59, 0.8);
            border-bottom: 3px solid rgba(100, 114, 125, 0.5);
            color: #ffffff;
            transition-property: background-color;
            transition-duration: .5s;
            border-radius: 10px;
          }

          button {
            box-shadow: inset 0 -3px transparent;
            border: none;
            border-radius: 0;
          }

          #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ffffff;
          }

          #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
          }

          #workspaces button.focused {
            background-color: #64727D;
            box-shadow: inset 0 -3px #ffffff;
          }

          #workspaces button.urgent {
            background-color: #eb4d4b;
          }

          #mode {
            background-color: #64727D;
            border-bottom: 3px solid #ffffff;
          }

          #clock,
          #battery,
          #cpu,
          #memory,
          #disk,
          #temperature,
          #backlight,
          #network,
          #pulseaudio,
          #wireplumber,
          #custom-media,
          #tray,
          #mode,
          #idle_inhibitor,
          #scratchpad,
          #mpd {
            padding: 0 10px;
            color: #ffffff;
          }

          #window,
          #workspaces {
            margin: 0 4px;
          }

          .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
          }

          .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
          }

          #clock {
            background-color: #64727D;
          }

          #battery {
            background-color: #ffffff;
            color: #000000;
          }

          #battery.charging, #battery.plugged {
            color: #ffffff;
            background-color: #26A65B;
          }

          @keyframes blink {
            to {
              background-color: #ffffff;
              color: #000000;
            }
          }

          #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: #ffffff;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          label:focus {
            background-color: #000000;
          }

          #cpu {
            background-color: #2ecc71;
            color: #000000;
          }

          #memory {
            background-color: #9b59b6;
          }

          #disk {
            background-color: #964B00;
          }

          #backlight {
            background-color: #90b1b1;
          }

          #network {
            background-color: #2980b9;
          }

          #network.disconnected {
            background-color: #f53c3c;
          }

          #pulseaudio {
            background-color: #f1c40f;
            color: #000000;
          }

          #pulseaudio.muted {
            background-color: #90b1b1;
            color: #2a5c45;
          }

          #wireplumber {
            background-color: #fff0f5;
            color: #000000;
          }

          #wireplumber.muted {
            background-color: #f53c3c;
          }

          #custom-media {
            background-color: #66cc99;
            color: #2a5c45;
            min-width: 100px;
          }

          #custom-media.custom-spotify {
            background-color: #66cc99;
          }

          #custom-media.custom-vlc {
            background-color: #ffa000;
          }

          #temperature {
            background-color: #f0932b;
          }

          #temperature.critical {
            background-color: #eb4d4b;
          }

          #tray {
            background-color: #2980b9;
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #eb4d4b;
          }

          #idle_inhibitor {
            background-color: #2d3748;
          }

          #idle_inhibitor.activated {
            background-color: #ecf0f1;
            color: #2d3748;
          }

          #mpd {
            background-color: #66cc99;
            color: #2a5c45;
          }

          #mpd.disconnected {
            background-color: #f53c3c;
          }

          #mpd.stopped {
            background-color: #90b1b1;
          }

          #mpd.paused {
            background-color: #51a37a;
          }

          #language {
            background: #00b093;
            color: #740864;
            padding: 0 5px;
            margin: 0 5px;
            min-width: 16px;
          }

          #keyboard-state {
            background: #97e1ad;
            color: #000000;
            padding: 0 0px;
            margin: 0 5px;
            min-width: 16px;
          }

          #keyboard-state > label {
            padding: 0 5px;
          }

          #keyboard-state > label.locked {
            background: rgba(0, 0, 0, 0.2);
          }

          #scratchpad {
            background: rgba(0, 0, 0, 0.2);
          }

          #scratchpad.empty {
          	background-color: transparent;
          }
        '';
      };

      # Mako notification service
      services.mako = {
        enable = true;
        settings = {
          background-color = "#2b303b";
          border-color = "#65737e";
          border-radius = 5;
          border-size = 2;
          text-color = "#c0c5ce";
          font = "JetBrains Mono 12";
          default-timeout = 5000;
          group-by = "summary";
        };
      };

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
        cursorTheme = {
          name = "Qogir";
          package = pkgs.qogir-icon-theme;
        };
      };

      # Hyprland configuration
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
            drop_shadow = true;
            shadow_range = 4;
            shadow_render_power = 3;
            shadow_offset = "0 2";
            "col.shadow" = "rgba(1a1a1aee)";
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
            "$mainMod, L, exec, swaylock-effects --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 00ff00 --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --fade-in 0.1" # Lock screen

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
            "swayidle -w timeout 300 'swaylock-effects --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 00ff00 --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --fade-in 0.1' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock-effects --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 00ff00 --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --fade-in 0.1' after-resume 'hyprctl dispatch dpms on'"
            # Ensure proper display handling
            "hyprctl dispatch dpms on"
            # Start wl-clipboard daemon
            "wl-paste --watch cliphist store"
          ];
        };
      };
    };
  };
})
