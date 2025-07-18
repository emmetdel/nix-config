# MacBook Pro Darwin Configuration
# TODO: Customize this configuration for your specific MacBook Pro
{
  user,
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # Development profile for comprehensive tooling
    inputs.self.profiles.development

    # Darwin-specific modules
    inputs.self.darwinModules.basic-system
    inputs.self.darwinModules.homebrew
  ];

  # System configuration
  system = {
    stateVersion = 5;

    # macOS system preferences
    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        mineffect = "genie";
        launchanim = true;
        show-process-indicators = true;
        tilesize = 48;
        static-only = true;
      };

      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        FXEnableExtensionChangeWarning = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };

  # Networking
  networking = {
    computerName = "MacBook Pro";
    hostName = "macbook-pro";
    localHostName = "macbook-pro";
  };

  # User configuration
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  # Homebrew configuration for macOS-specific apps
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/services"
    ];

    brews = [
      # Additional CLI tools not available in nixpkgs
      "mas" # Mac App Store CLI
    ];

    casks = [
      # Browsers
      "firefox"
      "google-chrome"

      # Development
      "visual-studio-code"
      "docker"
      "postman"

      # Communication
      "slack"
      "discord"
      "zoom"

      # Productivity
      "obsidian"
      "notion"
      "1password"

      # Media
      "spotify"
      "vlc"

      # Utilities
      "alfred"
      "bartender-4"
      "cleanmymac"
      "the-unarchiver"

      # Design
      "figma"

      # Fonts
      "font-fira-code"
      "font-jetbrains-mono"
      "font-source-code-pro"
    ];

    masApps = {
      # Mac App Store applications
      "Xcode" = 497799835;
      "TestFlight" = 899247664;
    };
  };

  # Services
  services = {
    nix-daemon.enable = true;

    # Yabai window manager (optional)
    # yabai = {
    #   enable = true;
    #   config = {
    #     layout = "bsp";
    #     auto_balance = "off";
    #     split_ratio = 0.50;
    #     window_border = "on";
    #     window_border_width = 2;
    #   };
    # };

    # skhd hotkey daemon (optional)
    # skhd = {
    #   enable = true;
    #   skhdConfig = ''
    #     # Window management
    #     alt - h : yabai -m window --focus west
    #     alt - j : yabai -m window --focus south
    #     alt - k : yabai -m window --focus north
    #     alt - l : yabai -m window --focus east
    #   '';
    # };
  };

  # Environment configuration
  environment = {
    systemPackages = with pkgs; [
      # Essential tools
      curl
      wget
      git

      # Development tools
      nodejs
      python3
      rustc
      cargo

      # Text editors
      neovim

      # Terminal tools
      tmux
      tree
      htop

      # File management
      unzip
      zip

      # Network tools
      nmap
      dig
    ];

    variables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
    };
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      fira-code
      jetbrains-mono
      source-code-pro
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
  };

  # Security
  security.pam.enableSudoTouchId = true;

  # TODO: Configure additional macOS-specific settings
  # TODO: Set up development environment specifics
  # TODO: Configure backup and sync settings
}
