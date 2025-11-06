{ config, pkgs, ... }:

{
  # Enable Zsh system-wide
  programs.zsh.enable = true;
  
  # Set Zsh as default shell for user
  users.users.emmetdelaney.shell = pkgs.zsh;
  
  # User groups (minimal - removed docker/podman)
  users.users.emmetdelaney.extraGroups = [
    "wheel"           # Sudo access
    "networkmanager"  # Network management
    "video"           # Video device access
    "audio"           # Audio device access
  ];
}
