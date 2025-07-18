# Development Profile
# Comprehensive development environment configuration
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
    groups = ["wheel" "networkmanager" "docker" "video" "audio" "dialout"];
  };

  # Comprehensive development environment
  common.development = {
    enable = true;
    languages = {
      python = {
        enable = true;
        versions = ["python39" "python310" "python311" "python312"];
        packages = ["pip" "pipenv" "poetry" "virtualenv"];
      };
      nodejs = {
        enable = true;
        versions = ["nodejs_18" "nodejs_20" "nodejs_21"];
        packages = ["npm" "yarn" "pnpm"];
      };
      rust = {
        enable = true;
        components = ["rustc" "cargo" "rustfmt" "clippy" "rust-analyzer"];
      };
      go = {
        enable = true;
        packages = ["go" "gopls" "golangci-lint" "delve"];
      };
      cpp = {
        enable = true;
        packages = ["gcc" "clang" "cmake" "ninja" "gdb" "lldb"];
      };
      java = {
        enable = true;
        packages = ["openjdk17" "openjdk21" "maven" "gradle"];
      };
      nix = {
        enable = true;
        packages = ["nixpkgs-fmt" "nil" "nix-tree" "nix-du"];
      };
      web = {
        enable = true;
        packages = ["typescript" "eslint" "prettier" "sass"];
      };
    };
    tools = {
      git = {
        enable = true;
        ui = ["gitui" "lazygit" "gh"];
      };
      editors = {
        vscode = true;
        neovim = true;
        emacs = false;
      };
      containers = {
        docker = true;
        podman = true;
        kubernetes = true;
      };
      databases = {
        postgresql = true;
        mysql = true;
        sqlite = true;
        redis = true;
        mongodb = true;
      };
      cloud = {
        aws = true;
        gcp = true;
        azure = true;
        terraform = true;
        ansible = true;
      };
      monitoring = {
        prometheus = true;
        grafana = true;
        jaeger = true;
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

  # Development-specific packages
  environment.systemPackages = with pkgs; [
    # Version control
    git
    git-lfs
    gitui
    lazygit
    gh

    # Editors and IDEs
    vscode
    neovim

    # Terminal tools
    tmux
    screen
    zellij

    # File management
    tree
    fd
    ripgrep
    fzf
    bat
    exa

    # Network tools
    curl
    wget
    httpie
    postman

    # API development
    insomnia

    # Database tools
    dbeaver
    pgcli
    mycli

    # Container tools
    docker
    docker-compose
    podman
    kubectl
    helm
    k9s

    # Cloud tools
    awscli2
    google-cloud-sdk
    azure-cli
    terraform
    ansible

    # Monitoring
    prometheus
    grafana

    # Build tools
    cmake
    ninja
    meson
    bazel

    # Documentation
    pandoc
    hugo

    # Security tools
    nmap
    wireshark
    burpsuite

    # Performance tools
    hyperfine
    flamegraph
    perf-tools

    # Virtualization
    qemu
    virtualbox
    vagrant

    # Communication
    slack
    discord

    # Browsers for testing
    firefox
    chromium

    # Design tools
    figma-linux

    # Utilities
    jq
    yq
    xmlstarlet
    protobuf
    grpcurl
  ];

  # Development services
  services = {
    # Enable Docker
    docker.enable = true;

    # Enable PostgreSQL for development
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
    };

    # Enable Redis for development
    redis = {
      enable = true;
      bind = "127.0.0.1";
    };
  };

  # Development environment variables
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  # Enable virtualization
  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };
}
