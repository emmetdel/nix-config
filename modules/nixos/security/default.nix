{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dotfiles.security;
in {
  options.dotfiles.security = {
    # Firewall options
    enableFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the firewall";
    };

    allowedTCPPorts = mkOption {
      type = types.listOf types.port;
      default = [22]; # SSH by default
      description = "List of allowed TCP ports";
    };

    allowedUDPPorts = mkOption {
      type = types.listOf types.port;
      default = [];
      description = "List of allowed UDP ports";
    };

    # SSH options
    enableSSH = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable SSH";
    };

    permitRootLogin = mkOption {
      type = types.enum ["yes" "no" "prohibit-password" "without-password" "forced-commands-only"];
      default = "no";
      description = "Whether to permit root login via SSH";
    };

    passwordAuthentication = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to allow password authentication for SSH";
    };

    # Kernel hardening options
    enableKernelHardening = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable kernel hardening";
    };

    # Other security options
    protectKernelImage = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to protect the kernel image";
    };

    hideProcessInformation = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to hide process information from other users";
    };

    lockBootloader = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to lock the bootloader";
    };
  };

  config = {
    # Firewall configuration
    networking.firewall = mkIf cfg.enableFirewall {
      enable = true;
      allowedTCPPorts = cfg.allowedTCPPorts;
      allowedUDPPorts = cfg.allowedUDPPorts;
    };

    # SSH hardening
    services.openssh = mkIf cfg.enableSSH {
      enable = true;
      settings = {
        PermitRootLogin = cfg.permitRootLogin;
        PasswordAuthentication = cfg.passwordAuthentication;
        KbdInteractiveAuthentication = cfg.passwordAuthentication;
      };
    };

    # Kernel hardening
    boot.kernel.sysctl = mkIf cfg.enableKernelHardening {
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.tcp_syncookies" = 1;
    };

    # Other security settings
    security = {
      protectKernelImage = cfg.protectKernelImage;
      hideProcessInformation = cfg.hideProcessInformation;
      lockBootloader = cfg.lockBootloader;
    };
  };
}
