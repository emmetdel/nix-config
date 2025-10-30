{ config, pkgs, ... }:

{
  # Enable Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
  
  # Enable Podman as Docker alternative
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;  # Alias docker to podman
    defaultNetwork.settings.dns_enabled = true;
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

