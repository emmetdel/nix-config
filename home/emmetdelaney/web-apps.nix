{ config, pkgs, ... }:

let
  # Define web apps with PWA support
  webApps = {
    gmail = {
      name = "Gmail";
      url = "https://mail.google.com";
      usePWA = true;
      key = "G";
    };
    calendar = {
      name = "Calendar";
      url = "https://calendar.google.com";
      usePWA = true;
      key = "C";
    };
    github = {
      name = "GitHub";
      url = "https://github.com";
      usePWA = false;  # Open in Firefox for better dev tools
      key = "H";
    };
    linear = {
      name = "Linear";
      url = "https://linear.app";
      usePWA = true;
      key = "L";
    };
    notion = {
      name = "Notion";
      url = "https://notion.so";
      usePWA = true;
      key = "N";
    };
    chatgpt = {
      name = "ChatGPT";
      url = "https://chat.openai.com";
      usePWA = true;
      key = "A";  # A for AI
    };
  };

  # PWA launcher - creates dedicated app windows with chromium
  launchPWA = pkgs.writeShellScript "launch-pwa" ''
    name="$1"
    url="$2"
    
    # Create data directory for this PWA
    data_dir="$HOME/.local/share/web-apps/$name"
    mkdir -p "$data_dir"
    
    # Launch as chromium app (looks and feels native!)
    ${pkgs.chromium}/bin/chromium \
      --app="$url" \
      --name="$name" \
      --class="$name" \
      --user-data-dir="$data_dir" \
      --no-first-run \
      --no-default-browser-check \
      2>/dev/null &
  '';

  # Web app launcher menu (accessible via Super+W)
  webAppLauncher = pkgs.writeShellScript "web-apps" ''
    #!/usr/bin/env bash
    
    # Build menu with app names
    choices=""
    ${builtins.concatStringsSep "\n    " (map (name: 
      let app = webApps.${name}; in
      ''choices="$choices${app.name}\n"''
    ) (builtins.attrNames webApps))}
    
    # Show rofi menu
    selection=$(echo -e "$choices" | ${pkgs.rofi}/bin/rofi -dmenu -p "Web App" -i)
    
    if [ -z "$selection" ]; then
      exit 0
    fi
    
    # Launch selected app
    ${builtins.concatStringsSep "\n    " (map (name:
      let app = webApps.${name}; in
      ''
      if [ "$selection" = "${app.name}" ]; then
        ${if app.usePWA then
          ''${launchPWA} "${app.name}" "${app.url}"''
        else
          ''${pkgs.firefox}/bin/firefox --new-window "${app.url}" &''
        }
      fi
      ''
    ) (builtins.attrNames webApps))}
  '';

  # Individual PWA launchers for direct keybindings
  pwaLaunchers = builtins.listToAttrs (map (name:
    let app = webApps.${name}; in
    {
      name = "launch-${name}";
      value = pkgs.writeShellScript "launch-${name}" ''
        ${if app.usePWA then
          ''${launchPWA} "${app.name}" "${app.url}"''
        else
          ''${pkgs.firefox}/bin/firefox --new-window "${app.url}" &''
        }
      '';
    }
  ) (builtins.attrNames webApps));

in
{
  # Install web app launcher
  home.packages = [ webAppLauncher ] ++ (builtins.attrValues pwaLaunchers);
  
  # Create desktop entries for PWAs (they appear in Rofi launcher!)
  home.file = builtins.listToAttrs (map (name:
    let app = webApps.${name}; in
    {
      name = ".local/share/applications/${app.name}.desktop";
      value = if app.usePWA then {
        text = ''
          [Desktop Entry]
          Version=1.0
          Type=Application
          Name=${app.name}
          Exec=${launchPWA} "${app.name}" "${app.url}"
          Icon=web-browser
          Categories=Network;WebBrowser;
          StartupWMClass=${app.name}
          Comment=Web app for ${app.name}
        '';
      } else null;
    }
  ) (builtins.filter (name: webApps.${name}.usePWA) (builtins.attrNames webApps)));
  
  # Make scripts executable and add to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];
  
  # Export web apps configuration for use in Hyprland window rules
  home.sessionVariables = {
    # Define PWA window classes for Hyprland rules
    PWA_APPS = builtins.concatStringsSep "," (map (name: webApps.${name}.name) 
      (builtins.filter (name: webApps.${name}.usePWA) (builtins.attrNames webApps)));
  };
}