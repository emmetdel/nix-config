{ config, pkgs, ... }:

{
  # Enable Zsh system-wide
  programs.zsh.enable = true;
  
  # Set Zsh as default shell for user
  users.users.emmetdelaney.shell = pkgs.zsh;
  
  # Additional user groups for development
  users.users.emmetdelaney.extraGroups = [
    "wheel"        # Sudo access
    "networkmanager"  # Network management
    "docker"       # Docker access
    "podman"       # Podman access
    "video"        # Video device access
    "audio"        # Audio device access
  ];
}

