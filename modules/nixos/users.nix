{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options = {
    users = {
      enable = mkEnableOption "common user configuration";
      adminUser = mkOption {
        type = types.str;
        default = "emmet";
        description = "The main admin user name";
      };
      adminGroups = mkOption {
        type = types.listOf types.str;
        default = ["wheel" "admins"];
        description = "Groups the admin user should be part of";
      };
      adminKeys = mkOption {
        type = types.listOf types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8FgRH4auak56a+6sqKbIt7EfFUBScSmWptqZbRF4W5"
        ];
        description = "SSH keys for the admin user";
      };
      deployUser = mkOption {
        type = types.str;
        default = "deploy";
        description = "The deploy user name";
      };
      deployKeys = mkOption {
        type = types.listOf types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8FgRH4auak56a+6sqKbIt7EfFUBScSmWptqZbRF4W5"
        ];
        description = "SSH keys for the deploy user";
      };
      wheelNeedsPassword = mkOption {
        type = types.bool;
        default = false;
        description = "Whether wheel group members need password for sudo";
      };
      hashedPasswordFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Path to file containing the hashed password for the admin user";
      };
      hashedPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The hashed password for the admin user (use hashedPasswordFile instead for security)";
      };
      initialPassword = mkOption {
        type = types.nullOr types.str;
        default = "password";
        description = "Initial password for the admin user (only used if no hashed password is provided)";
      };
    };
  };

  config = lib.mkIf config.users.enable {
    # Configure the admin user
    users.users.${config.users.adminUser} =
      {
        isNormalUser = true;
        description = "System Administrator - Emmet Delaney";
        extraGroups = config.users.adminGroups;
        openssh.authorizedKeys.keys = config.users.adminKeys;
      }
      // (
        if config.users.hashedPasswordFile != null
        then {
          hashedPasswordFile = config.users.hashedPasswordFile;
        }
        else if config.users.hashedPassword != null
        then {
          hashedPassword = config.users.hashedPassword;
        }
        else {
          initialPassword = config.users.initialPassword;
        }
      );

    # Configure the deploy user
    # Configure the deploy user
    users.users.${config.users.deployUser} = {
      isNormalUser = true;
      description = "Deploy User";
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = config.users.deployKeys;
    };

    # Configure sudo settings
    security.sudo.wheelNeedsPassword = config.users.wheelNeedsPassword;

    # Allow deploy user to run all commands without password (for deployment)
    security.sudo.extraRules = [
      {
        users = [config.users.deployUser];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
