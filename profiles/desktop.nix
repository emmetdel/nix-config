# Desktop Profile
# Complete desktop workstation configuration
{
  inputs,
  outputs,
  pkgs,
  user,
  ...
}: {
  imports = [
    # Common modules
    inputs.self.commonModules.users
    inputs.self.commonModules.development
    inputs.self.commonModules.security
    inputs.self.commonModules.networking

    # Platform-specific modules (imported by host)
    # inputs.self.nixosModules.desktop
    # inputs.self.nixosModules.basic-system
  ];

  # Common user configuration
  common.users = {
    enable = true;
    primaryUser = {
      username = user;
      fullName = "Emmet Delaney";
      email = "emmet@emmetdelaney.com";
      shell = pkgs.zsh;
    };
    deployUser.enable = true;
    groups = ["wheel" "networkmanager" "docker" "video" "audio"];
  };

  # Development environment
  common.development = {
    enable = true;
    languages = {
      python.enable = true;
      nodejs.enable = true;
      rust.enable = true;
      go.enable = true;
      cpp.enable = true;
      nix.enable = true;
    };
    tools = {
      git.enable = true;
      editors = {
        vscode = true;
        neovim = true;
      };
      containers.docker = true;
      databases = {
        postgresql = true;
        sqlite = true;
      };
    };
  };

  # Security configuration
  common.security = {
    enable = true;
    ssh = {
      enable = true;
      passwordAuthentication = false;
      rootLogin = false;
    };
    firewall.enable = true;
    tools.enable = true;
  };

  # Networking configuration
  common.networking = {
    enable = true;
    networkManager = {
      enable = true;
      wifi.enable = true;
    };
    bluetooth.enable = true;
    printing.enable = true;
    tools.enable = true;
  };

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    # Browsers
    firefox
    chromium

    # Communication
    slack
    discord
    teams-for-linux
    thunderbird

    # Productivity
    obsidian
    libreoffice

    # Media
    vlc
    spotify

    # Graphics
    gimp
    inkscape

    # File management
    nautilus

    # Security
    _1password-gui

    # Utilities
    htop
    btop
    tree
    unzip
    zip
  ];
}
