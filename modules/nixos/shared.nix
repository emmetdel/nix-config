# Shared NixOS configuration that imports all available modules
# This can be imported by all hosts to have access to all modules
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Import all available NixOS modules
    ./gc.nix
    ./desktop.nix
    ./development.nix
    ./amd-optimization.nix
    ./basic-system.nix
    ./users.nix
  ];

  # Common configuration that applies to all systems
  # This can be overridden by individual host configurations

  # Enable garbage collection by default
  gc.enable = lib.mkDefault true;

  # Common system packages
  environment.systemPackages = with pkgs; [
    # Basic utilities
    wget
    curl
    htop
    tree
    ripgrep
    fd
    bat
    eza
    fzf
  ];

  # Common security settings
  security = {
    # Allow sudo without password for wheel group
    sudo.wheelNeedsPassword = false;

    # Enable auditd for security monitoring
    auditd.enable = true;
  };

  # Common networking settings
  networking = {
    # Enable NetworkManager by default
    networkmanager.enable = true;

    # Common firewall settings
    firewall = {
      enable = true;
      # Allow SSH
      allowedTCPPorts = [22];
      # Allow ICMP for ping
      allowedUDPPorts = [];
    };
  };

  # Common time settings
  time.timeZone = lib.mkDefault "Europe/Dublin";
  services.timesyncd.enable = true;

  # Common boot settings
  boot = {
    # Enable systemd-boot by default
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Common kernel parameters
    kernelParams = [
      "quiet"
      "splash"
    ];
  };

  # Common system settings
  system = {
    # Enable auto-upgrade
    autoUpgrade = {
      enable = false; # Disabled by default, enable per host if needed
      allowReboot = false;
    };

    # State version
    stateVersion = "25.05";
  };
}
