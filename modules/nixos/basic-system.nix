{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.basic-system;
in {
  options.basic-system = {
    enable = mkEnableOption "Enable basic system configuration";
    hostname = mkOption {
      type = types.str;
      description = "Hostname for the system";
    };
    timezone = mkOption {
      type = types.str;
      default = "Europe/Dublin";
      description = "Timezone for the system";
    };
    ssh = {
      enable = mkEnableOption "Enable SSH server";
      authorizedKeys = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "SSH authorized keys for the user";
      };
    };
    packages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional system packages";
    };
  };

  config = mkIf cfg.enable {
    # Set the hostname
    networking.hostName = cfg.hostname;

    # Configure bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Configure time settings
    time.timeZone = cfg.timezone;
    services.timesyncd.enable = true;
    services.timesyncd.servers = [
      "time.google.com"
      "time1.google.com"
      "time2.google.com"
      "time3.google.com"
    ];

    # Configure SSH
    services.sshd.enable = cfg.ssh.enable;
    services.openssh = mkIf cfg.ssh.enable {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Add basic system packages
    environment.systemPackages = with pkgs;
      [
        htop
      ]
      ++ cfg.packages;
  };
}
