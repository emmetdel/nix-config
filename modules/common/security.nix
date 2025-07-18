# Common Security Configuration Module
# Cross-platform security settings and tools
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.common.security;
in {
  options.common.security = {
    enable = mkEnableOption "common security configuration";

    ssh = {
      enable = mkEnableOption "SSH security configuration";

      port = mkOption {
        type = types.port;
        default = 22;
        description = "SSH port";
      };

      allowedUsers = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Users allowed to SSH";
      };

      passwordAuthentication = mkOption {
        type = types.bool;
        default = false;
        description = "Allow password authentication";
      };

      rootLogin = mkOption {
        type = types.bool;
        default = false;
        description = "Allow root login";
      };

      maxAuthTries = mkOption {
        type = types.int;
        default = 3;
        description = "Maximum authentication attempts";
      };
    };

    firewall = {
      enable = mkEnableOption "firewall configuration";

      allowedTCPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "Allowed TCP ports";
      };

      allowedUDPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "Allowed UDP ports";
      };

      allowPing = mkOption {
        type = types.bool;
        default = true;
        description = "Allow ping responses";
      };
    };

    fail2ban = {
      enable = mkEnableOption "fail2ban intrusion prevention";

      maxRetry = mkOption {
        type = types.int;
        default = 5;
        description = "Maximum retry attempts before ban";
      };

      banTime = mkOption {
        type = types.str;
        default = "10m";
        description = "Ban duration";
      };
    };

    auditd = {
      enable = mkEnableOption "audit daemon for security monitoring";
    };

    apparmor = {
      enable = mkEnableOption "AppArmor mandatory access control";
    };

    antivirus = {
      enable = mkEnableOption "ClamAV antivirus";

      updateFrequency = mkOption {
        type = types.str;
        default = "daily";
        description = "Virus definition update frequency";
      };
    };

    tools = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install security tools";
      };

      packages = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [
          nmap
          wireshark-cli
          tcpdump
          netcat
          openssl
        ];
        description = "Security tools to install";
      };
    };
  };

  config = mkIf cfg.enable {
    # Common security packages
    environment.systemPackages = with pkgs;
      [
        # Basic security tools
        gnupg
        openssl

        # Network security
        nmap
        netcat

        # File integrity
        aide
      ]
      ++ optionals cfg.tools.enable cfg.tools.packages;

    # Common security settings that work across platforms
    # Platform-specific implementations will extend these
  };
}
