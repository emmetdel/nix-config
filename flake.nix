{
  description = "NixOS Development Desktop Configuration for Nebula";

  inputs = {
    # Use the latest stable NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Hardware optimization
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home Manager for user-specific configurations
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake utils for multi-system support
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    flake-utils,
    ...
  } @ inputs: {
    nixosConfigurations = {
      nebula = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # Hardware configuration
          ./hardware-configuration.nix

          # AMD-specific optimizations for Beelink SER8
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd

          # Home Manager integration
          home-manager.nixosModules.home-manager

          # Main configuration
          ({
            config,
            pkgs,
            ...
          }: {
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
            environment.etc."greetd/tuigreet".text = ''
              [terminal]
              vt = 1
              font = "JetBrains Mono"
              font_size = 12

              [colors]
              background = "#1a1a1a"
              foreground = "#ffffff"
              accent = "#7aa2f7"
              error = "#f7768e"
              success = "#9ece6a"
              warning = "#e0af68"
            '';

            # Required for Wayland
            security.polkit.enable = true;

            # Power management and sleep handling
            powerManagement = {
              enable = true;
              powertop.enable = true;
            };

            # Screen management and sleep handling
            services = {
              # ... existing services ...

              # Improved power management
              upower.enable = true;

              # Better screen management
              xserver = {
                # ... existing xserver config ...
                enable = true;
                displayManager.startx.enable = false;
              };
            };

            # Hardware-specific power management for AMD
            hardware = {
              # ... existing hardware config ...

              # AMD power management
              opengl.enable = true;
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
              # beekeeper-studio - not working
              pgadmin4

              # Additional useful development tools
              docker-compose
              postman
              vscodium # Open source VSCode alternative

              # Hyprland ecosystem
              waybar # Status bar
              wofi # Application launcher
              mako # Notification daemon
              swaylock-effects # Screen locker
              swayidle # Idle management
              wlogout # Logout menu
              grim # Screenshot functionality
              slurp # Select area for screenshots
              wl-clipboard # Clipboard utilities
              brightnessctl # Brightness control
              pamixer # Audio control

              # Display and power management
              greetd.tuigreet # Login manager
              greetd.gtkgreet # Alternative login manager
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

            # Cursor IDE installation (if available in nixpkgs, otherwise we'll use alternatives)
            # Note: Cursor might not be available in nixpkgs, so we include VSCodium as alternative

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

                # Waybar configuration - Improved with inspiration from woioeow/hyprland-dotfiles
                programs.waybar = {
                  enable = true;
                  settings = {
                    mainBar = {
                      layer = "top";
                      position = "top";
                      height = 30;
                      spacing = 4;
                      margin = "6px 6px 0px 6px";
                      radius = 8;
                      fixed-center = true;

                      modules-left = ["hyprland/workspaces" "hyprland/mode"];
                      modules-center = ["hyprland/window"];
                      modules-right = ["pulseaudio" "network" "cpu" "memory" "battery" "clock" "tray"];

                      "hyprland/workspaces" = {
                        disable-scroll = true;
                        all-outputs = true;
                        format = "{icon}";
                        on-click = "activate";
                        sort-by-number = true;
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
                          urgent = "!";
                          focused = "●";
                          default = "○";
                        };
                      };

                      "hyprland/mode" = {
                        format = "<span style=\"italic\">{}</span>";
                      };

                      "hyprland/window" = {
                        format = "{}";
                        separate-outputs = true;
                        max-length = 50;
                      };

                      clock = {
                        timezone = "Europe/Dublin";
                        format = "{:%H:%M}";
                        format-alt = "{:%Y-%m-%d %H:%M}";
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
                      };

                      cpu = {
                        interval = 1;
                        format = "CPU {usage}%";
                        format-alt = "CPU {avg_frequency} GHz";
                        tooltip = false;
                        on-click = "kitty -e htop";
                      };

                      memory = {
                        interval = 1;
                        format = "RAM {}%";
                        format-alt = "RAM {used:0.1f}G/{total:0.1f}G";
                        on-click = "kitty -e htop";
                      };

                      network = {
                        interval = 1;
                        format-wifi = "WiFi {signalStrength}%";
                        format-ethernet = "Ethernet";
                        format-linked = "{ifname}";
                        format-disconnected = "Disconnected";
                        format-alt = "{ifname}: {ipaddr}/{cidr}";
                        tooltip-format = "{ifname} via {gwaddr}";
                        max-length = 50;
                        on-click = "nm-connection-editor";
                      };

                      pulseaudio = {
                        format = "{volume}% {icon}";
                        format-bluetooth = "{volume}% {icon}";
                        format-bluetooth-muted = " {icon}";
                        format-muted = " {icon}";
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
                        scroll-step = 1;
                      };

                      battery = {
                        states = {
                          warning = 30;
                          critical = 15;
                        };
                        format = "{capacity}% {icon}";
                        format-charging = "{capacity}% ";
                        format-plugged = "{capacity}% ";
                        format-alt = "{time} {icon}";
                        format-icons = ["" "" "" "" "" ""];
                        on-click = "kitty -e htop";
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
                      font-family: "JetBrains Mono", "SF Pro Display", "Helvetica Neue", Arial, sans-serif;
                      font-size: 13px;
                      font-weight: 500;
                      min-height: 0;
                    }

                    window#waybar {
                      background: rgba(30, 30, 30, 0.95);
                      color: #ffffff;
                      border-radius: 8px;
                      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
                      transition-property: background-color;
                      transition-duration: 0.3s;
                    }

                    #workspaces {
                      background: rgba(0, 0, 0, 0.2);
                      border-radius: 6px;
                      margin: 4px 8px;
                      padding: 0 4px;
                    }

                    #workspaces button {
                      padding: 4px 8px;
                      margin: 2px 1px;
                      background: transparent;
                      color: #888888;
                      border-radius: 4px;
                      transition: all 0.2s ease;
                    }

                    #workspaces button:hover {
                      background: rgba(255, 255, 255, 0.1);
                      color: #ffffff;
                    }

                    #workspaces button.active {
                      background: rgba(255, 255, 255, 0.2);
                      color: #ffffff;
                    }

                    #workspaces button.urgent {
                      background: rgba(255, 100, 100, 0.8);
                      color: #ffffff;
                    }

                    #mode {
                      background: rgba(255, 100, 100, 0.8);
                      color: #ffffff;
                      padding: 4px 8px;
                      border-radius: 4px;
                      margin: 4px 8px;
                    }

                    #window {
                      padding: 0 12px;
                      color: #ffffff;
                      font-weight: 400;
                    }

                    #clock {
                      background: rgba(0, 0, 0, 0.2);
                      color: #ffffff;
                      padding: 4px 12px;
                      border-radius: 6px;
                      margin: 4px 8px;
                      font-weight: 600;
                    }

                    #cpu,
                    #memory,
                    #network,
                    #pulseaudio,
                    #battery {
                      background: rgba(0, 0, 0, 0.2);
                      color: #ffffff;
                      padding: 4px 12px;
                      border-radius: 6px;
                      margin: 4px 4px;
                      transition: all 0.2s ease;
                    }

                    #cpu:hover,
                    #memory:hover,
                    #network:hover,
                    #pulseaudio:hover,
                    #battery:hover {
                      background: rgba(255, 255, 255, 0.1);
                    }

                    #cpu {
                      color: #7aa2f7;
                    }

                    #memory {
                      color: #bb9af7;
                    }

                    #network {
                      color: #7dcfff;
                    }

                    #pulseaudio {
                      color: #f7768e;
                    }

                    #battery {
                      color: #9ece6a;
                    }

                    #battery.charging {
                      color: #9ece6a;
                    }

                    #battery.warning {
                      color: #e0af68;
                    }

                    #battery.critical {
                      color: #f7768e;
                      animation: blink 1s infinite;
                    }

                    #tray {
                      background: rgba(0, 0, 0, 0.2);
                      border-radius: 6px;
                      margin: 4px 8px;
                      padding: 0 8px;
                    }

                    #tray > * {
                      padding: 0 4px;
                    }

                    @keyframes blink {
                      0%, 50% { opacity: 1; }
                      51%, 100% { opacity: 0.3; }
                    }

                    /* Tooltip styling */
                    tooltip {
                      background: rgba(30, 30, 30, 0.95);
                      border: 1px solid rgba(255, 255, 255, 0.1);
                      border-radius: 6px;
                      color: #ffffff;
                      padding: 8px;
                    }

                    tooltip label {
                      color: #ffffff;
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
                      "$mainMod, L, exec, swaylock" # Lock screen

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
                      # Improved idle and sleep handling
                      "swayidle -w timeout 300 'swaylock -f -c 000000' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f -c 000000' after-resume 'hyprctl dispatch dpms on'"
                      # Ensure proper display handling
                      "hyprctl dispatch dpms on"
                      # Start wl-pasteboard for clipboard
                      "wl-pasteboard"
                    ];
                  };
                };
              };
            };
          })
        ];
      };
    };
  };
}
