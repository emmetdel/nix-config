{
  config,
  pkgs,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 300;
        no_fade_in = false;
        no_fade_out = false;
      };

      background = [
        {
          monitor = "";
          path = "";
          color = "000000";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "200, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          font_color = "000000";
          inner_color = "ffffff";
          outer_color = "000000";
          outline_thickness = 5;
          placeholder_text = ''Password...'';
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "ffffff";
          font_size = 48;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %d %B %Y")"'';
          color = "ffffff";
          font_size = 24;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
