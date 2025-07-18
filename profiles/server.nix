# Server Profile
# Minimal server configuration for headless systems
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
    groups = ["wheel" "docker"];
  };

  # Minimal development environment
  common.development = {
    enable = true;
    languages = {
      python.enable = true;
      nodejs.enable = true;
      nix.enable = true;
    };
    tools = {
      git.enable = true;
      editors = {
        neovim = true;
      };
      containers.docker = true;
      databases = {
        postgresql = true;
        sqlite = true;
      };
    };
  };

  # Enhanced security for servers
  common.security = {
    enable = true;
    ssh = {
      enable = true;
      passwordAuthentication = false;
      rootLogin = false;
      allowedUsers = [user "deploy"];
    };
    firewall = {
      enable = true;
      strict = true;
    };
    tools.enable = true;
    fail2ban.enable = true;
  };

  # Server networking
  common.networking = {
    enable = true;
    networkManager.enable = false; # Use systemd-networkd for servers
    bluetooth.enable = false;
    printing.enable = false;
    tools.enable = true;
  };

  # Server-specific packages
  environment.systemPackages = with pkgs; [
    # System monitoring
    htop
    btop
    iotop
    nethogs

    # Network tools
    curl
    wget
    dig
    nmap
    tcpdump

    # File management
    tree
    unzip
    zip
    rsync

    # Text processing
    jq
    yq

    # Process management
    tmux
    screen

    # Security
    fail2ban

    # Backup tools
    restic
    rclone

    # Container tools
    docker-compose

    # Monitoring
    prometheus-node-exporter
  ];

  # Server-specific services
  services = {
    # Enable SSH
    openssh.enable = true;

    # System monitoring
    prometheus.exporters.node = {
      enable = true;
      enabledCollectors = ["systemd"];
    };

    # Log management
    journald.settings = {
      SystemMaxUse = "1G";
      MaxRetentionSec = "1month";
    };
  };

  # Disable unnecessary services for servers
  services.xserver.enable = false;
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Optimize for server workloads
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
  };
}
