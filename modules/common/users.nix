# Common User Configuration Module
# Cross-platform user management for NixOS and Darwin
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.common.users;
in {
  options.common.users = {
    enable = mkEnableOption "common user configuration";

    primaryUser = {
      username = mkOption {
        type = types.str;
        default = "emmet";
        description = "Primary user username";
      };

      fullName = mkOption {
        type = types.str;
        default = "Emmet Delaney";
        description = "Full name of the primary user";
      };

      email = mkOption {
        type = types.str;
        default = "emmet@emmetdelaney.com";
        description = "Email address of the primary user";
      };

      sshKeys = mkOption {
        type = types.listOf types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8FgRH4auak56a+6sqKbIt7EfFUBScSmWptqZbRF4W5"
        ];
        description = "SSH public keys for the primary user";
      };

      shell = mkOption {
        type = types.package;
        default = pkgs.zsh;
        description = "Default shell for the primary user";
      };
    };

    deployUser = {
      enable = mkEnableOption "deploy user for automation";

      username = mkOption {
        type = types.str;
        default = "nixos-deploy";
        description = "Deploy user username";
      };

      sshKeys = mkOption {
        type = types.listOf types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHblA3QwMwsej6rfGbueXE3X8C3i22Q+3hGZ9MgRVk49"
        ];
        description = "SSH public keys for the deploy user";
      };
    };

    groups = mkOption {
      type = types.listOf types.str;
      default = ["wheel"];
      description = "Additional groups for the primary user";
    };
  };

  config = mkIf cfg.enable {
    # This module provides options that can be used by platform-specific implementations
    # The actual user creation is handled by nixos/users.nix or darwin/users.nix
  };
}
