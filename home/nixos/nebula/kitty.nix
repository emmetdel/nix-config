({
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 12;
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      mouse_hide_wait = 2;
      select_by_word_characters = "@-./_~?&=%+#";
      remember_window_size = false;
      initial_window_width = 1200;
      initial_window_height = 800;
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      background_opacity = "0.95";
      # Wayland-specific
      wayland_titlebar_color = "system";
      linux_display_server = "wayland";
    };
  };
})
