{
  config,
  pkgs,
  theme,
  ...
}: {
  # Kitty terminal configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 15;
    };
    settings = {
      # Tokyo Night theme colors from theme.nix
      foreground = theme.palette.foreground;
      background = theme.palette.background;
      selection_foreground = theme.palette.background;
      selection_background = theme.palette.color6; # Cyan

      # Black
      color0 = theme.palette.color0;
      color8 = theme.palette.color8;

      # Red
      color1 = theme.palette.color1;
      color9 = theme.palette.color9;

      # Green
      color2 = theme.palette.color2;
      color10 = theme.palette.color10;

      # Yellow
      color3 = theme.palette.color3;
      color11 = theme.palette.color11;

      # Blue
      color4 = theme.palette.color4;
      color12 = theme.palette.color12;

      # Magenta
      color5 = theme.palette.color5;
      color13 = theme.palette.color13;

      # Cyan
      color6 = theme.palette.color6;
      color14 = theme.palette.color14;

      # White
      color7 = theme.palette.color7;
      color15 = theme.palette.color15;

      # Cursor
      cursor = theme.palette.cursor;
      cursor_text_color = theme.palette.background;

      # Window
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };
  };
}
