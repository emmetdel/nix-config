({
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];

  # ============================================================================
  # System Configuration
  # ============================================================================
  system.stateVersion = "25.05";

  # ============================================================================
  # Boot Configuration
  # ============================================================================
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

  # ============================================================================
  # Networking
  # ============================================================================
  networking = {
    hostName = "nebula";
    networkmanager.enable = true;
    # Enable firewall but allow common development ports
    firewall = {
      enable = true;
      allowedTCPPorts = [3000 8000 8080 5173]; # Common dev ports
    };
  };

  # ============================================================================
  # Time and Locale
  # ============================================================================
  time.timeZone = "Europe/Dublin"; # Adjust to your timezone
  i18n.defaultLocale = "en_IE.UTF-8"; # Adjust to your locale

  # ============================================================================
  # Audio Configuration
  # ============================================================================
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ============================================================================
  # Bluetooth Configuration
  # ============================================================================
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

  # ============================================================================
  # Display and Graphics
  # ============================================================================
  hardware = {
    # AMD power management
    graphics.enable = true;
  };

  # ============================================================================
  # Wayland and Desktop Environment
  # ============================================================================
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

  # Required for Wayland
  security.polkit.enable = true;

  # ============================================================================
  # Display Manager
  # ============================================================================
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

  # ============================================================================
  # X Server Configuration
  # ============================================================================
  services.xserver = {
    enable = true;
    displayManager.startx.enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # ============================================================================
  # Power Management
  # ============================================================================
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Systemd sleep handling
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  # ============================================================================
  # Services
  # ============================================================================
  services = {
    # Improved power management
    upower.enable = true;

    # Printing support
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Flatpak for additional app support
    flatpak.enable = true;
  };

  # ============================================================================
  # Virtualization
  # ============================================================================
  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable libvirtd for VMs if needed
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # ============================================================================
  # Programs and Development Tools
  # ============================================================================
  # Enable ZSH system-wide
  programs.zsh.enable = true;

  # ============================================================================
  # Fonts
  # ============================================================================
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    jetbrains-mono
    font-awesome
    material-design-icons
    nerd-fonts.jetbrains-mono
  ];

  # ============================================================================
  # Nix Configuration
  # ============================================================================
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

  # ============================================================================
  # User Configuration
  # ============================================================================
  users.users.emmetdelaney = {
    # Change "developer" to your username
    isNormalUser = true;
    description = "Development User";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd"];
    shell = pkgs.zsh;
    # Add your password hash here (replace with your own)
    hashedPassword = "$6$DQ33iq.40kbw39V.$ScAQ52zZyqIf7X211/uZ2IJjzcsnxMZZkCfBMLASqgMQtziRZeVxMUz4S04vTZuLc66Vc1OXjwU4/6mclKoml.";
  };

  # ============================================================================
  # Home Manager Configuration
  # ============================================================================
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup"; # Customize backup file extension
    users.emmetdelaney = {
      # Change to your username
      home.stateVersion = "25.05";

      imports = [
        ../../../home/nixos/nebula/session-variables.nix
        ../../../home/nixos/nebula/git.nix
        ../../../home/nixos/nebula/kitty.nix
        ../../../home/nixos/nebula/zsh.nix
        ../../../home/nixos/nebula/direnv.nix
        ../../../home/nixos/nebula/waybar.nix
        ../../../home/nixos/nebula/hyprland.nix
        ../../../home/nixos/nebula/mako.nix
        ../../../home/nixos/nebula/gtk.nix
        ../../../home/nixos/nebula/firefox.nix
        ../../../home/nixos/nebula/wlogout.nix
        ../../../home/nixos/nebula/hyprlock.nix
      ];
    };
  };
})
