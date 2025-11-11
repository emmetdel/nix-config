{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Browsers
    brave # Main browser for research
    chromium # PWA engine for web apps

    # Editor
    vscode-fhs # Code editor

    # Terminal
    kitty

    # Wayland essentials
    rofi # Application launcher
    waybar # Status bar
    mako # Notifications
    grim # Screenshots
    slurp # Region select for screenshots
    wl-clipboard # Clipboard utilities
    swaylock # Screen lock
    swaybg # Wallpaper

    # File manager
    xfce.thunar # GUI file manager

    # Essential CLI tools
    fd # Better find
    ripgrep # Better grep
    eza # Better ls with icons
    htop # System monitor
    direnv # Environment switcher

    # Network
    networkmanagerapplet

    # Bluetooth
    blueman

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    inter # More readable system font
  ];

  # Brave configuration for Wayland
  programs.brave = {
    enable = true;
  };

  # Kitty terminal configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 16;
    };
    settings = {
      # Tokyo Night theme colors (inline)
      foreground = "#c0caf5";
      background = "#1a1b26";
      selection_foreground = "#1a1b26";
      selection_background = "#7dcfff";

      # Black
      color0 = "#15161e";
      color8 = "#414868";

      # Red
      color1 = "#f7768e";
      color9 = "#f7768e";

      # Green
      color2 = "#9ece6a";
      color10 = "#9ece6a";

      # Yellow
      color3 = "#e0af68";
      color11 = "#e0af68";

      # Blue
      color4 = "#7aa2f7";
      color12 = "#7aa2f7";

      # Magenta
      color5 = "#bb9af7";
      color13 = "#bb9af7";

      # Cyan
      color6 = "#7dcfff";
      color14 = "#7dcfff";

      # White
      color7 = "#c0caf5";
      color15 = "#c0caf5";

      # Cursor
      cursor = "#7dcfff";
      cursor_text_color = "#1a1b26";

      # Window
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };
  };

  # Direnv for automatic environment activation
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
