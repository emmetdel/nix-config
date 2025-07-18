# Common Networking Configuration Module
# Cross-platform networking settings and tools
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.common.networking;
in {
  options.common.networking = {
    enable = mkEnableOption "common networking configuration";

    hostname = mkOption {
      type = types.str;
      description = "System hostname";
      example = "desktop";
    };

    domain = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "System domain name";
      example = "local";
    };

    nameservers = mkOption {
      type = types.listOf types.str;
      default = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];
      description = "DNS nameservers";
    };

    networkManager = {
      enable = mkEnableOption "NetworkManager";

      wifi = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable WiFi support";
        };

        powersave = mkOption {
          type = types.bool;
          default = false;
          description = "Enable WiFi power saving";
        };
      };

      ethernet = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Ethernet support";
        };
      };
    };

    vpn = {
      wireguard = {
        enable = mkEnableOption "WireGuard VPN support";
      };

      openvpn = {
        enable = mkEnableOption "OpenVPN support";
      };
    };

    bluetooth = {
      enable = mkEnableOption "Bluetooth support";

      powerOnBoot = mkOption {
        type = types.bool;
        default = true;
        description = "Power on Bluetooth adapter on boot";
      };

      settings = mkOption {
        type = types.attrs;
        default = {
          General = {
            Enable = "Source,Sink,Media,Socket";
            Experimental = true;
          };
        };
        description = "Bluetooth configuration settings";
      };
    };

    printing = {
      enable = mkEnableOption "network printing support";

      drivers = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [hplip];
        description = "Printer drivers";
      };

      discovery = mkOption {
        type = types.bool;
        default = true;
        description = "Enable printer discovery";
      };
    };

    tools = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install networking tools";
      };

      packages = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [
          wget
          curl
          dig
          nmap
          iperf3
          mtr
          traceroute
          whois
        ];
        description = "Networking tools to install";
      };
    };
  };

  config = mkIf cfg.enable {
    # Common networking packages
    environment.systemPackages = with pkgs;
      [
        # Basic networking tools
        wget
        curl

        # DNS tools
        dig
        nslookup

        # Network diagnostics
        ping
        traceroute
        mtr
      ]
      ++ optionals cfg.tools.enable cfg.tools.packages;

    # Common networking settings
    # Platform-specific implementations will extend these
    networking = {
      hostName = cfg.hostname;
      domain = cfg.domain;
      nameservers = cfg.nameservers;
    };
  };
}
