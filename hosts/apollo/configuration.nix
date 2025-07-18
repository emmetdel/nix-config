# Apollo Desktop Configuration
# Running on Beelink SER8
{
  user,
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # Import hardware configuration
    ./hardware-configuration.nix
    # Import the disko configuration for disk setup
    ./hardware/disko.nix
    # Import home-manager module
    inputs.home-manager.nixosModules.home-manager
    # Import the gc module for garbage collection
    inputs.self.nixosModules.gc
    # Import specific nixos modules
    inputs.self.nixosModules.users
    inputs.self.nixosModules.basic-system
    inputs.self.nixosModules.desktop
    inputs.self.nixosModules.development
    inputs.self.nixosModules.amd-optimization
  ];

  # Enable garbage collection
  gc.enable = true;

  # Enable users module
  users = {
    enable = true;
    adminUser = "emmet";
    deployUser = "nixos-deploy"; # Match what deploy-rs expects
    deployKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHblA3QwMwsej6rfGbueXE3X8C3i22Q+3hGZ9MgRVk49" # nixos-deploy key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8FgRH4auak56a+6sqKbIt7EfFUBScSmWptqZbRF4W5" # admin key
    ];
    wheelNeedsPassword = false;
    initialPassword = "password"; # Simple password for initial login
  };

  # Basic system configuration
  basic-system = {
    enable = true;
    hostname = "apollo";
    timezone = "Europe/Dublin";
    ssh = {
      enable = true;
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8FgRH4auak56a+6sqKbIt7EfFUBScSmWptqZbRF4W5"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHblA3QwMwsej6rfGbueXE3X8C3i22Q+3hGZ9MgRVk49"
      ];
    };
    packages = with pkgs; [
      # System monitoring and utilities
      htop
      iotop
      nethogs
      btop
      lm_sensors
      nvtopPackages.full
      # Filesystem tools
      btrfs-progs

      # programs - should these be in home-manager?
      kitty
      firefox
      neovim
      kdePackages.dolphin

      # Communication and productivity apps
      slack
      teams-for-linux
      thunderbird # Alternative to Outlook as Outlook isn't available in nixpkgs

      # Development tools
      code-cursor
      beekeeper-studio

      # Note-taking and file sync
      obsidian
      onedrive

      # Security
      _1password-gui
    ];
  };

  # Desktop environment configuration
  desktop = {
    enable = true;
    hyprland.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
    printing.enable = true;
    autoLogin = {
      enable = true;
      user = "emmet";
    };
  };

  # Development environment
  development = {
    enable = true;
    languages = {
      python.enable = true;
      nodejs.enable = true;
      rust.enable = true;
      cpp.enable = true;
    };
    tools = {
      vscode.enable = true;
    };
  };

  # AMD optimizations for Beelink SER8
  amd-optimization = {
    enable = true;
    cpu = {
      updateMicrocode = true;
      coreCount = 16; # SER8 has AMD Ryzen 7 8845HS (8 cores, 16 threads)
    };
    gpu = {
      enable = true; # SER8 has AMD Radeon 780M integrated GPU
    };
  };

  # Enable graphics (formerly OpenGL) - Enhanced configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Mesa drivers for better compatibility
      mesa.drivers
      # Video acceleration
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  # Enable Docker for development
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  # Add additional groups for the admin user
  users.users.${user}.extraGroups = ["networkmanager" "docker" "video" "audio"];

  # Enable network manager
  networking.networkmanager.enable = true;

  # Enable CUPS for printing
  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
  };

  # Enable scanning
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
  };

  # Enable flatpak for additional application support
  # services.flatpak.enable = true;

  # Enable firmware updates
  services.fwupd.enable = true;

  # Enable automatic system updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "github:emmetdelaney/dotfiles";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "weekly";
  };

  # Enable home-manager module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${user} = {
      imports = [
        inputs.self.homeManagerModules.hyprland
      ];
      home.stateVersion = "25.05";
      programs.home-manager.enable = true;

      # Enable Hyprland configuration
      hyprland = {
        enable = true;
        terminal = "kitty";
        menu = "wofi --show drun";
        fileManager = "dolphin";
        browser = "firefox";
        editor = "code";
      };
    };
  };

  # Systemd service to reload Hyprland config on changes
  systemd.user.services.hyprland-reload = {
    description = "Reload Hyprland configuration";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "hyprland-reload" ''
        # Check if Hyprland is running
        if pgrep -x "Hyprland" > /dev/null; then
          echo "Reloading Hyprland configuration..."
          ${pkgs.hyprland}/bin/hyprctl reload || echo "Failed to reload Hyprland config"
        fi

        # Restart waybar if running
        if pgrep -x "waybar" > /dev/null; then
          echo "Restarting waybar..."
          pkill waybar
          sleep 1
          ${pkgs.waybar}/bin/waybar &
        fi
      ''}";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
