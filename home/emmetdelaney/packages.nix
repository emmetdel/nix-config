{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Original packages from configuration.nix
    zed-editor
    vscode-fhs
    firefox
    
    # Terminal emulator
    kitty
    
    # File managers
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    yazi  # Terminal file manager
    
    # Application launcher
    rofi
    wofi  # Alternative Wayland launcher
    
    # Status bar
    waybar
    
    # Notifications
    mako
    
    # Audio control
    pavucontrol
    
    # Network management GUI
    networkmanagerapplet
    
    # Media viewers
    imv        # Image viewer
    zathura    # PDF viewer
    mpv        # Video player
    
    # System utilities
    btop       # System monitor
    neofetch   # System info
    htop       # Process viewer
    
    # Screenshot tools
    grim
    slurp
    wl-clipboard
    
    # Shell and CLI tools
    fd         # Better find
    ripgrep    # Better grep
    eza        # Better ls
    bat        # Better cat
    fzf        # Fuzzy finder
    zoxide     # Smart cd
    tmux       # Terminal multiplexer
    
    # Git and version control
    gh         # GitHub CLI
    git-lfs    # Git Large File Storage
    lazygit    # Terminal UI for git
    
    # Development tools
    gnumake
    gcc
    cmake
    
    # Clipboard manager
    wl-clipboard
    cliphist
    
    # Password management
    bitwarden-desktop  # Desktop app (renamed from bitwarden)
    bitwarden-cli      # CLI tool
    
    # Container tools
    docker-compose
    podman-compose
    
    # Productivity
    jq         # JSON processor
    yq-go      # YAML processor
    tree       # Directory tree
    unzip
    zip
    
    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  # Firefox configuration for Wayland
  programs.firefox = {
    enable = true;
  };

  # Kitty terminal configuration (colors set in themes.nix)
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.9";
      confirm_os_window_close = 0;
    };
  };
}