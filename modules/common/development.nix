# Common Development Configuration Module
# Cross-platform development tools and environment setup
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.common.development;
in {
  options.common.development = {
    enable = mkEnableOption "common development configuration";

    languages = {
      python = {
        enable = mkEnableOption "Python development environment";
        version = mkOption {
          type = types.str;
          default = "python311";
          description = "Python version to use";
        };
        packages = mkOption {
          type = types.listOf types.str;
          default = ["pip" "virtualenv" "poetry"];
          description = "Python packages to install globally";
        };
      };

      nodejs = {
        enable = mkEnableOption "Node.js development environment";
        version = mkOption {
          type = types.str;
          default = "nodejs_20";
          description = "Node.js version to use";
        };
        enableYarn = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Yarn package manager";
        };
        enablePnpm = mkOption {
          type = types.bool;
          default = true;
          description = "Enable pnpm package manager";
        };
      };

      rust = {
        enable = mkEnableOption "Rust development environment";
        components = mkOption {
          type = types.listOf types.str;
          default = ["rustc" "cargo" "rustfmt" "clippy"];
          description = "Rust components to install";
        };
      };

      go = {
        enable = mkEnableOption "Go development environment";
        version = mkOption {
          type = types.str;
          default = "go_1_21";
          description = "Go version to use";
        };
      };

      cpp = {
        enable = mkEnableOption "C++ development environment";
        compiler = mkOption {
          type = types.str;
          default = "gcc";
          description = "C++ compiler to use (gcc or clang)";
        };
      };

      nix = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Nix development tools";
        };
      };
    };

    tools = {
      git = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Git configuration";
        };
        userName = mkOption {
          type = types.str;
          default = config.common.users.primaryUser.fullName or "Emmet Delaney";
          description = "Git user name";
        };
        userEmail = mkOption {
          type = types.str;
          default = config.common.users.primaryUser.email or "emmet@emmetdelaney.com";
          description = "Git user email";
        };
      };

      editors = {
        vscode = mkEnableOption "Visual Studio Code";
        neovim = mkEnableOption "Neovim";
        vim = mkEnableOption "Vim";
      };

      containers = {
        docker = mkEnableOption "Docker";
        podman = mkEnableOption "Podman";
      };

      databases = {
        postgresql = mkEnableOption "PostgreSQL client tools";
        mysql = mkEnableOption "MySQL client tools";
        sqlite = mkEnableOption "SQLite";
        redis = mkEnableOption "Redis client tools";
      };
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional development packages";
    };
  };

  config = mkIf cfg.enable {
    # Common development packages that work across platforms
    environment.systemPackages = with pkgs;
      [
        # Version control
        git
        gh

        # Text processing
        jq
        yq

        # Network tools
        curl
        wget

        # Archive tools
        unzip
        zip

        # Build tools
        gnumake

        # Terminal utilities
        tree
        htop
      ]
      ++ optionals cfg.languages.python.enable [
        (pkgs.${cfg.languages.python.version}.withPackages (ps:
          with ps; [
            pip
            virtualenv
          ]))
        poetry
      ]
      ++ optionals cfg.languages.nodejs.enable [
        pkgs.${cfg.languages.nodejs.version}
        nodejs.pkgs.npm
      ]
      ++ optionals (cfg.languages.nodejs.enable && cfg.languages.nodejs.enableYarn) [
        yarn
      ]
      ++ optionals (cfg.languages.nodejs.enable && cfg.languages.nodejs.enablePnpm) [
        nodePackages.pnpm
      ]
      ++ optionals cfg.languages.rust.enable [
        rustc
        cargo
        rustfmt
        clippy
      ]
      ++ optionals cfg.languages.go.enable [
        pkgs.${cfg.languages.go.version}
      ]
      ++ optionals cfg.languages.cpp.enable [
        (
          if cfg.languages.cpp.compiler == "clang"
          then clang
          else gcc
        )
        cmake
        pkg-config
      ]
      ++ optionals cfg.languages.nix.enable [
        nil
        nixpkgs-fmt
        alejandra
      ]
      ++ optionals cfg.tools.editors.vscode [
        vscode
      ]
      ++ optionals cfg.tools.editors.neovim [
        neovim
      ]
      ++ optionals cfg.tools.editors.vim [
        vim
      ]
      ++ optionals cfg.tools.databases.postgresql [
        postgresql
      ]
      ++ optionals cfg.tools.databases.mysql [
        mysql80
      ]
      ++ optionals cfg.tools.databases.sqlite [
        sqlite
      ]
      ++ optionals cfg.tools.databases.redis [
        redis
      ]
      ++ cfg.packages;
  };
}
