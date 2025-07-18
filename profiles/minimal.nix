# Minimal Profile
# Bare minimum configuration for basic systems
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
    inputs.self.commonModules.security
    inputs.self.commonModules.networking
  ];

  # Basic user configuration
  common.users = {
    enable = true;
    primaryUser = {
      username = user;
      fullName = "Emmet Delaney";
      email = "emmet@emmetdelaney.com";
      shell = pkgs.bash; # Use bash for minimal systems
    };
    deployUser.enable = true;
    groups = ["wheel"];
  };

  # Basic security
  common.security = {
    enable = true;
    ssh = {
      enable = true;
      passwordAuthentication = false;
      rootLogin = false;
    };
    firewall.enable = true;
    tools.enable = false; # Minimal security tools
  };

  # Basic networking
  common.networking = {
    enable = true;
    networkManager.enable = false; # Use systemd-networkd
    bluetooth.enable = false;
    printing.enable = false;
    tools.enable = false; # Minimal network tools
  };

  # Minimal system packages
  environment.systemPackages = with pkgs; [
    # Essential tools
    curl
    wget
    git

    # Text editors
    nano
    vim

    # File management
    tree
    unzip
    zip

    # System monitoring
    htop

    # Network tools
    dig

    # Process management
    tmux
  ];

  # Minimal services
  services = {
    # Enable SSH
    openssh.enable = true;

    # Basic log management
    journald.settings = {
      SystemMaxUse = "500M";
      MaxRetentionSec = "1week";
    };
  };

  # Disable unnecessary services
  services.xserver.enable = false;
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Optimize for minimal resource usage
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
  };

  # Minimal documentation
  documentation = {
    enable = false;
    nixos.enable = false;
    man.enable = true;
    info.enable = false;
  };
}
