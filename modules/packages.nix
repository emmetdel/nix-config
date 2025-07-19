{pkgs}: {
  all-packages = {
    # Core system packages for NixOS
    core = with pkgs; [
      # System utilities
      coreutils
      curl
      wget
      git
      vim
      htop
      ripgrep
      fd
      tree
      unzip
      zip

      # System monitoring and management
      btop
      iotop
      lsof

      # Network utilities
      inetutils
      nmap
      dig
      whois

      # Development basics
      gnumake
      gcc
    ];

    # Command-line tools for user environments
    cli-tools = with pkgs; [
      # Shell utilities
      zsh
      bash
      tmux
      fzf
      jq
      yq

      # Version control
      git
      gh

      # Text processing
      vim
      neovim

      # File management
      exa
      bat
      fd
      ripgrep

      # Network tools
      curl
      wget
      httpie

      # System monitoring
      htop
      btop

      # Terminal multiplexers and enhancers
      tmux
      starship
    ];

    # Development tools for user environments
    development = with pkgs; [
      # Languages and runtimes
      nodejs
      python3
      rustup
      go

      # Build tools
      gnumake
      cmake
      ninja

      # Development tools
      vscode
      docker-compose

      # Language servers and formatters
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.prettier
      python310Packages.black
      python310Packages.pylint
      rust-analyzer
      gopls

      # Git tools
      git-lfs
      gitui
    ];

    # Desktop applications for user environments
    desktop = with pkgs; [
      # Browsers
      firefox
      chromium

      # Communication
      slack
      discord

      # Media
      vlc
      mpv

      # Office
      libreoffice

      # Graphics
      gimp
      inkscape

      # Utilities
      keepassxc
      syncthing
    ];
  };
}
