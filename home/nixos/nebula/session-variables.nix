({
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    # Wayland-specific
    NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
    MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland for Firefox
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    # Display and sleep handling
    WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor issues
    WLR_RENDERER = "vulkan"; # Better rendering
    # Power management
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "hyprland";
  };
})
