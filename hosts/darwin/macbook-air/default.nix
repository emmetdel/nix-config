# MacBook Air Darwin Configuration
# TODO: Customize this configuration for your specific MacBook Air
{
  user,
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # Minimal profile for better battery life and performance
    inputs.self.profiles.minimal

    # Darwin-specific modules
    inputs.self.darwinModules.basic-system
    inputs.self.darwinModules.homebrew
  ];

  # System configuration
  system = {
    stateVersion = 5;

    # macOS system preferences optimized for MacBook Air
    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        mineffect = "scale"; # Less resource intensive than genie
        launchanim = false; # Disable for better performance
        show-process-indicators = true;
        tilesize = 36; # Smaller for Air's screen
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
        # Power saving settings
        "com.apple.sound.beep.flash" = 0;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      # Energy saving settings
      universalaccess = {
        reduceMotion = true; # Reduce animations for better battery
      };
    };
  };

  # Networking
  networking = {
    computerName = "MacBook Air";
    hostName = "macbook-air";
    localHostName = "macbook-air";
  };

  # User configuration
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    shell = pkgs.bash; # Use bash for minimal setup
  };

  # Minimal Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false; # Manual updates for control
      cleanup = "zap";
      upgrade = false; # Manual upgrades
    };

    taps = [
      "homebrew/cask"
    ];

    brews = [
      # Essential CLI tools only
      "mas" # Mac App Store CLI
    ];

    casks = [
      # Essential applications only
      "firefox"
      "visual-studio-code"
      "1password"
      "the-unarchiver"
    ];

    masApps = {
      # Essential Mac App Store applications
      "TestFlight" = 899247664;
    };
  };

  # Services
  services = {
    nix-daemon.enable = true;
  };

  # Minimal environment configuration
  environment = {
    systemPackages = with pkgs; [
      # Essential tools only
      curl
      wget
      git

      # Basic development
      nodejs
      python3

      # Text editor
      nano
      vim

      # Terminal tools
      tree
      htop

      # File management
      unzip
      zip
    ];

    variables = {
      EDITOR = "vim";
      BROWSER = "firefox";
    };
  };

  # Essential fonts only
  fonts = {
    packages = with pkgs; [
      source-code-pro
    ];
  };

  # Security
  security.pam.enableSudoTouchId = true;

  # Power management optimizations for MacBook Air
  system.defaults.alf = {
    globalstate = 1; # Enable firewall for security
  };

  # TODO: Configure power management settings
  # TODO: Set up minimal development environment
  # TODO: Configure iCloud sync settings for documents
}
