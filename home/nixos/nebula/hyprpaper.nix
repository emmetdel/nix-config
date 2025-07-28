{
  config,
  pkgs,
  ...
}: {
  programs.hyprpaper = {
    enable = true;
    settings = {
      # Set the wallpaper path here
      # Example: "/home/user/Pictures/wallpaper.jpg"
      # You can also use different wallpapers for different monitors
      # Example: "monitor=DP-1, /home/user/Pictures/wallpaper1.jpg"
      wallpaper = [
        # Add your wallpaper paths here
        # ",/home/user/Pictures/wallpaper.jpg"
      ];

      # Preload wallpapers to avoid loading delays
      # preload = [
      #   "/home/user/Pictures/wallpaper.jpg"
      # ];
    };
  };
}
