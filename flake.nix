{
  description = "NixOS Development Desktop Configuration for Beelink SER8";

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
      # Replace "beelink-ser8" with your desired hostname
      beelink-ser8 = nixpkgs.lib.nixosSystem {
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
              hostName = "beelink-ser8";
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

            # Display Manager
            services.greetd = {
              enable = true;
              settings = {
                default_session = {
                  command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
                  user = "greeter";
                };
              };
            };

            # Required for Wayland
            security.polkit.enable = true;

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
              beekeeper-studio

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
              noto-fonts-cjk
              noto-fonts-emoji
              liberation_ttf
              fira-code
              fira-code-symbols
              jetbrains-mono
              (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "JetBrainsMono"];})
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

                # Waybar configuration
                programs.waybar = {
                  enable = true;
                  settings = {
                    mainBar = {
                      layer = "top";
                      position = "top";
                      height = 35;
                      spacing = 4;

                      modules-left = ["hyprland/workspaces" "hyprland/mode" "hyprland/window"];
                      modules-center = ["clock"];
                      modules-right = ["idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "tray"];

                      "hyprland/workspaces" = {
                        disable-scroll = true;
                        all-outputs = true;
                        format = "{name}: {icon}";
                        format-icons = {
                          "1" = "";
                          "2" = "";
                          "3" = "";
                          "4" = "";
                          "5" = "";
                          urgent = "";
                          focused = "";
                          default = "";
                        };
                      };

                      clock = {
                        timezone = "Europe/Dublin";
                        format = "{:%Y-%m-%d %H:%M}";
                        format-alt = "{:%A, %B %d, %Y (%R)}";
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
                        format = " {usage}%";
                        tooltip = false;
                      };

                      memory = {
                        format = " {}%";
                      };

                      network = {
                        format-wifi = "  {signalStrength}%";
                        format-ethernet = " {ipaddr}/{cidr}";
                        tooltip-format = "{ifname} via {gwaddr}";
                        format-linked = " {ifname} (No IP)";
                        format-disconnected = "⚠ Disconnected";
                        format-alt = "{ifname}: {ipaddr}/{cidr}";
                      };

                      pulseaudio = {
                        format = "{volume}% {icon} {format_source}";
                        format-bluetooth = "{volume}% {icon} {format_source}";
                        format-bluetooth-muted = " {icon} {format_source}";
                        format-muted = " {format_source}";
                        format-source = " {volume}%";
                        format-source-muted = "";
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
                      };
                    };
                  };

                  style = ''
                    * {
                      border: none;
                      border-radius: 0;
                      font-family: JetBrains Mono, Helvetica, Arial, sans-serif;
                      font-size: 14px;
                      min-height: 0;
                    }

                    window#waybar {
                      background: rgba(43, 48, 59, 0.5);
                      border-bottom: 3px solid rgba(100, 114, 125, 0.5);
                      color: #ffffff;
                      transition-property: background-color;
                      transition-duration: .5s;
                    }

                    #workspaces button {
                      padding: 0 5px;
                      background-color: transparent;
                      color: #ffffff;
                      border-bottom: 3px solid transparent;
                    }

                    #workspaces button:hover {
                      background: rgba(0, 0, 0, 0.2);
                      box-shadow: inset 0 -3px #ffffff;
                      border-bottom: 3px solid #ffffff;
                    }

                    #workspaces button.focused {
                      background-color: #64727D;
                      border-bottom: 3px solid #ffffff;
                    }

                    #mode {
                      background-color: #64727D;
                      border-bottom: 3px solid #ffffff;
                    }

                    #clock,
                    #battery,
                    #cpu,
                    #memory,
                    #network,
                    #pulseaudio,
                    #tray,
                    #mode,
                    #idle_inhibitor {
                      padding: 0 10px;
                      color: #ffffff;
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
                  '';
                };

                # Mako notification service
                services.mako = {
                  enable = true;
                  backgroundColor = "#2b303b";
                  borderColor = "#65737e";
                  borderRadius = 5;
                  borderSize = 2;
                  textColor = "#c0c5ce";
                  font = "JetBrains Mono 12";
                  defaultTimeout = 5000;
                  groupBy = "summary";
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

                    # Keybindings
                    "$mainMod" = "SUPER";
                    bind = [
                      # Basic bindings
                      "$mainMod, Q, exec, kitty"
                      "$mainMod, C, killactive,"
                      "$mainMod, M, exit,"
                      "$mainMod, E, exec, thunar"
                      "$mainMod, V, togglefloating,"
                      "$mainMod, R, exec, wofi --show drun"
                      "$mainMod, P, pseudo, # dwindle"
                      "$mainMod, J, togglesplit, # dwindle"

                      # Move focus with mainMod + arrow keys
                      "$mainMod, left, movefocus, l"
                      "$mainMod, right, movefocus, r"
                      "$mainMod, up, movefocus, u"
                      "$mainMod, down, movefocus, d"

                      # Switch workspaces with mainMod + [0-9]
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

                      # Move active window to a workspace with mainMod + SHIFT + [0-9]
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

                      # Scroll through existing workspaces with mainMod + scroll
                      "$mainMod, mouse_down, workspace, e+1"
                      "$mainMod, mouse_up, workspace, e-1"

                      # Screenshot bindings
                      ", Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png"
                      "$mainMod, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png"

                      # Application shortcuts
                      "$mainMod, B, exec, firefox"
                      "$mainMod, S, exec, slack"
                      "$mainMod, O, exec, obsidian"
                      "$mainMod, L, exec, swaylock"
                    ];

                    # Mouse bindings
                    bindm = [
                      "$mainMod, mouse:272, movewindow"
                      "$mainMod, mouse:273, resizewindow"
                    ];

                    # Media keys
                    bindel = [
                      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
                      ", XF86AudioLowerVolume, exec, pamixer -d 5"
                      ", XF86AudioMute, exec, pamixer -t"
                      ", XF86AudioMicMute, exec, pamixer --default-source -t"
                      ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
                      ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                    ];

                    # Auto-start applications
                    exec-once = [
                      "waybar"
                      "mako"
                      "nm-applet --indicator"
                      "blueman-applet"
                      "1password --silent"
                      "swayidle -w timeout 300 'swaylock -f -c 000000' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f -c 000000'"
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
