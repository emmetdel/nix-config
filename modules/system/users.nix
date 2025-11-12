{ config, pkgs, userConfig, ... }:

{
  # Enable Zsh system-wide
  programs.zsh.enable = true;

  # User configuration (consolidated from all modules)
  users.users.${userConfig.username} = {
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"           # Sudo access
      "video"           # Video device access
      "audio"           # Audio device access
      "networkmanager"  # Network management
      "bluetooth"       # Bluetooth access
    ];
  };
}
