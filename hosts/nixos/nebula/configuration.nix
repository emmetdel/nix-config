{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/system
    ../../../modules/nixos/packages
    ../../../modules/nixos/services
    ../../../modules/nixos/security
  ];

  # Host-specific configuration
  networking.hostName = "nebula";
  networking.networkmanager.enable = true;

  # Configure the modules with host-specific settings
  dotfiles = {
    # System configuration
    system = {
      stateVersion = "25.05";
      timeZone = "Europe/Dublin";
      defaultLocale = "en_US.UTF-8";
      keyboardLayout = "us";
      enableDocker = true;
      enableGarbageCollection = true;
      gcDays = 30;
    };

    # Package configuration
    packages = {
      enableCore = true;
      extraPackages = with pkgs; [
        firefox
        thunderbird
      ];
    };

    # Service configuration
    services = {
      enablePipewire = true;
      enableFlatpak = true;
      enablePrinting = true;
      flatpakPackages = [
        "org.gimp.GIMP"
      ];
    };

    # Security configuration
    security = {
      enableFirewall = true;
      allowedTCPPorts = [22 80 443];
      allowedUDPPorts = [];
      enableSSH = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      enableKernelHardening = true;
      protectKernelImage = true;
      hideProcessInformation = true;
      lockBootloader = true;
    };
  };

  # Desktop environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # User configuration
  users.users.emmet = {
    isNormalUser = true;
    description = "Emmet Delaney";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # Enable automatic updates
  system.autoUpgrade.enable = true;
}
