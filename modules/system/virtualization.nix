{ config, pkgs, lib, ... }:

{
  
  # Use Podman with Docker compatibility instead of Docker
  # This provides docker CLI compatibility while using Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;  # Provides docker CLI compatibility
    defaultNetwork.settings.dns_enabled = true;
    # Auto-prune settings
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
  
  # Enable libvirtd for VMs
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
    };
  };
  
  # Install useful virtualization tools
  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
    dive  # Docker image explorer
  ];
}

