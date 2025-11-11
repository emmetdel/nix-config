{
  config,
  pkgs,
  ...
}: {
  # Rofi configuration with Tokyo Night theme
  programs.rofi = {
    enable = true;
    theme = "~/.config/rofi/theme.rasi";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "  Apps ";
      display-run = "  Run ";
      display-window = " 﩯 Window";
      sidebar-mode = true;
    };
  };

  # Rofi theme file with Tokyo Night colors
  home.file.".config/rofi/theme.rasi".text = ''
    * {
      bg: #1a1b26;
      bg-alt: #16161e;
      bg-selected: #292e42;

      fg: #c0caf5;
      fg-alt: #a9b1d6;

      border: #7aa2f7;

      background-color: @bg;
      text-color: @fg;
    }

    window {
      transparency: "real";
      background-color: @bg;
      border: 2px;
      border-color: @border;
      border-radius: 10px;
      width: 600px;
      padding: 20px;
    }

    mainbox {
      background-color: transparent;
      children: [inputbar, listview];
      spacing: 20px;
    }

    inputbar {
      background-color: @bg-alt;
      border-radius: 8px;
      padding: 10px;
      children: [prompt, entry];
    }

    prompt {
      background-color: transparent;
      text-color: @border;
      padding: 0 10px 0 0;
    }

    entry {
      background-color: transparent;
      placeholder: "Search...";
      placeholder-color: @fg-alt;
    }

    listview {
      background-color: transparent;
      lines: 8;
      scrollbar: false;
    }

    element {
      background-color: transparent;
      padding: 8px;
      border-radius: 6px;
    }

    element selected {
      background-color: @bg-selected;
      text-color: @border;
    }

    element-icon {
      size: 24px;
      padding: 0 10px 0 0;
    }

    element-text {
      background-color: transparent;
      text-color: inherit;
    }
  '';
}
