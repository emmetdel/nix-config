# Customization Guide

Learn how to make this configuration truly yours!

## 🎨 Theming

### Changing the Active Theme

Edit `home/emmetdelaney/themes.nix`:

```nix
# Select the active theme
activeTheme = themes.catppuccin-mocha;  # Change this line
```

Available themes:
- `tokyo-night` - Dark blue with vibrant accents (default)
- `catppuccin-mocha` - Warm, pastel dark theme
- `nord` - Cool, arctic-inspired palette
- `gruvbox` - Retro, warm color scheme

After changing, rebuild:
```bash
rebuild
```

### Creating a Custom Theme

Add your theme to `themes.nix`:

```nix
themes = {
  # ... existing themes ...
  
  my-custom-theme = {
    name = "My Custom Theme";
    colors = {
      bg = "#yourcolor";
      fg = "#yourcolor";
      # ... define all color variables
    };
  };
};

# Then activate it:
activeTheme = themes.my-custom-theme;
```

### Per-Application Theming

Each application can be themed individually:

**Kitty (Terminal)**:
```nix
programs.kitty.settings = {
  background = "#custom";
  foreground = "#custom";
  # ... more color settings
};
```

**Waybar**:
```nix
programs.waybar.style = ''
  window#waybar {
    background-color: #custom;
    color: #custom;
  }
'';
```

## 🔤 Fonts

### Changing Terminal Font

Edit `home/emmetdelaney/packages.nix`:

```nix
programs.kitty = {
  font = {
    name = "FiraCode Nerd Font";  # Change font
    size = 14;                     # Change size
  };
};
```

### Installing Additional Fonts

Add to `home/emmetdelaney/packages.nix`:

```nix
home.packages = with pkgs; [
  # Nerd Fonts (with icons)
  (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Hack" ]; })
  
  # Other fonts
  inter
  roboto
  ubuntu_font_family
];
```

### System-wide Font Configuration

Edit `home/emmetdelaney/themes.nix`:

```nix
gtk = {
  font = {
    name = "Inter";
    size = 11;
  };
};
```

## ⌨️ Keybindings

### Adding Custom Keybindings

Edit `home/emmetdelaney/hyprland.nix`:

```nix
bind = [
  # Your custom keybindings
  "$mod, B, exec, brave"                    # Launch Brave
  "$mod SHIFT, M, exec, spotify"            # Launch Spotify
  "$mod, N, exec, obsidian"                 # Launch Obsidian
  "$mod SHIFT, P, exec, 1password"          # Launch 1Password
  
  # Media keys
  ", XF86AudioPlay, exec, playerctl play-pause"
  ", XF86AudioNext, exec, playerctl next"
  ", XF86AudioPrev, exec, playerctl previous"
  
  # Brightness (for laptops)
  ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
  ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
];
```

### Changing the Modifier Key

By default, `Super` (Windows key) is used. To change:

```nix
"$mod" = "ALT";  # or "CTRL" (not recommended for Hyprland)
```

## 📦 Adding Software

### User Packages (Home Manager)

Edit `home/emmetdelaney/packages.nix`:

```nix
home.packages = with pkgs; [
  # Communication
  slack
  discord
  telegram-desktop
  
  # Media
  spotify
  vlc
  obs-studio
  
  # Development
  vscode
  postman
  dbeaver
  
  # Productivity
  obsidian
  libreoffice
  
  # Design
  inkscape
  gimp
  krita
];
```

### System Packages

For system-level packages, edit `hosts/helios/default.nix`:

```nix
environment.systemPackages = with pkgs; [
  # System utilities
  usbutils
  pciutils
  
  # Drivers
  # ... driver packages
];
```

### Enabling Services

Edit relevant module or add to `hosts/helios/default.nix`:

```nix
services = {
  # Database
  postgresql.enable = true;
  
  # Web server
  nginx.enable = true;
  
  # Printing
  printing.enable = true;
  
  # Bluetooth
  blueman.enable = true;
};
```

## 🖥️ Hyprland Customization

### Window Decorations

Edit `home/emmetdelaney/hyprland.nix`:

```nix
decoration = {
  rounding = 12;              # Rounded corners (0 = square)
  drop_shadow = true;
  shadow_range = 8;
  shadow_render_power = 4;
  
  blur = {
    enabled = true;
    size = 5;                 # Blur strength
    passes = 2;               # More passes = more blur
  };
};
```

### Animations

```nix
animations = {
  enabled = true;
  bezier = [
    "smooth, 0.25, 0.1, 0.25, 1.0"
    "bounce, 0.68, -0.55, 0.265, 1.55"
  ];
  
  animation = [
    "windows, 1, 5, smooth, popin 80%"
    "border, 1, 10, smooth"
    "fade, 1, 7, smooth"
    "workspaces, 1, 6, smooth, slide"
  ];
};
```

### Gaps and Borders

```nix
general = {
  gaps_in = 8;                # Inner gaps
  gaps_out = 12;              # Outer gaps
  border_size = 3;            # Border thickness
};
```

### Window Rules

```nix
windowrule = [
  # Float specific apps
  "float, ^(pavucontrol)$"
  "float, ^(nm-connection-editor)$"
  "float, ^(1Password)$"
  
  # Size rules
  "size 800 600, ^(pavucontrol)$"
  
  # Workspace rules
  "workspace 1, ^(firefox)$"
  "workspace 2, ^(code)$"
  "workspace 3, ^(spotify)$"
  
  # Opacity rules
  "opacity 0.9, ^(kitty)$"
  
  # No decorations
  "noborder, ^(wofi)$"
];
```

## 🚀 Terminal Customization

### Zsh Configuration

Edit `home/emmetdelaney/shell.nix`:

```nix
programs.zsh = {
  shellAliases = {
    # Add your custom aliases
    c = "clear";
    q = "exit";
    py = "python3";
    dk = "docker";
    dkc = "docker-compose";
    tf = "terraform";
    k = "kubectl";
    
    # Project shortcuts
    proj = "cd ~/projects";
    config = "cd ~/personal-code/nix-config";
  };
  
  initExtra = ''
    # Your custom zsh code
    export EDITOR="nvim"
    export VISUAL="nvim"
    
    # Custom functions
    mkcd() {
      mkdir -p "$1" && cd "$1"
    }
  '';
};
```

### Starship Prompt

Edit `home/emmetdelaney/shell.nix`:

```nix
programs.starship.settings = {
  # Change prompt format
  format = "$directory$git_branch$character";
  
  # Customize directory display
  directory = {
    truncation_length = 5;
    style = "bold cyan";
  };
  
  # Add more modules
  nodejs.disabled = false;
  python.disabled = false;
  rust.disabled = false;
  
  # Custom modules
  battery = {
    display = [{
      threshold = 30;
      style = "bold red";
    }];
  };
};
```

### Tmux Configuration

Edit `home/emmetdelaney/dev-tools.nix`:

```nix
programs.tmux = {
  prefix = "C-b";  # Change prefix key
  
  extraConfig = ''
    # Your custom tmux config
    set -g status-position bottom
    
    # Custom key bindings
    bind-key r source-file ~/.config/tmux/tmux.conf
    bind-key -n C-S-Left swap-window -t -1
    bind-key -n C-S-Right swap-window -t +1
  '';
};
```

## 🎯 Waybar Customization

### Adding Modules

Edit `home/emmetdelaney/hyprland.nix`:

```nix
programs.waybar.settings.mainBar = {
  modules-left = [ "hyprland/workspaces" "hyprland/window" ];
  modules-center = [ "clock" ];
  modules-right = [ 
    "idle_inhibitor"  # Add this
    "pulseaudio" 
    "network" 
    "cpu"             # Add this
    "memory"          # Add this
    "temperature"     # Add this
    "battery" 
    "tray" 
  ];
  
  # Configure new modules
  "cpu" = {
    format = "󰻠 {usage}%";
    tooltip = false;
  };
  
  "memory" = {
    format = "󰍛 {percentage}%";
  };
  
  "temperature" = {
    critical-threshold = 80;
    format = "{icon} {temperatureC}°C";
    format-icons = [ "" "" "" "" "" ];
  };
};
```

## 🔐 Password Manager Integration

### 1Password

Add to `home/emmetdelaney/packages.nix`:

```nix
home.packages = with pkgs; [
  _1password-gui
  _1password
];
```

### Bitwarden (Already Included)

The configuration includes Bitwarden. To customize:

```nix
# Add Bitwarden to startup
exec-once = [
  "bitwarden"
];

# Add keybinding
bind = [
  "$mod SHIFT, P, exec, bitwarden"
];
```

## 🌐 Web Apps Customization

Edit `home/emmetdelaney/utilities.nix`:

```nix
home.file.".local/bin/web-apps".source = pkgs.writeShellScript "web-apps" ''
  #!/usr/bin/env bash
  
  apps=(
    # Add your web apps
    "Gmail:https://gmail.com"
    "Calendar:https://calendar.google.com"
    "GitHub:https://github.com"
    "GitLab:https://gitlab.com"
    "Jira:https://yourcompany.atlassian.net"
    "Confluence:https://yourcompany.atlassian.net/wiki"
    "Slack:https://app.slack.com"
    "Discord:https://discord.com/app"
    "Twitter:https://twitter.com"
    "Reddit:https://reddit.com"
  )
  
  # ... rest of script
'';
```

## 🎮 Gaming Setup

Add gaming packages:

```nix
home.packages = with pkgs; [
  # Steam
  steam
  
  # Game launchers
  lutris
  heroic
  
  # Emulators
  retroarch
  
  # Tools
  gamemode
  mangohud
];
```

Enable in system:

```nix
# In hosts/helios/default.nix
programs.steam.enable = true;
programs.gamemode.enable = true;
```

## 📚 Development Environments

### Node.js

```nix
home.packages = with pkgs; [
  nodejs_20
  nodePackages.npm
  nodePackages.yarn
  nodePackages.pnpm
  nodePackages.typescript
];
```

### Python

```nix
home.packages = with pkgs; [
  python311
  python311Packages.pip
  python311Packages.virtualenv
  poetry
];
```

### Rust

```nix
home.packages = with pkgs; [
  rustc
  cargo
  rust-analyzer
  rustfmt
];
```

## 🔄 Updating and Maintenance

### Update Strategy

```bash
# Update flake inputs
update  # alias for: nix flake update

# Update and rebuild
update && rebuild

# Cleanup old generations
cleanup  # Keep system lean
```

### Backup Your Config

```bash
# Initialize git if not already
cd ~/personal-code/nix-config
git init
git add .
git commit -m "Initial config"

# Push to GitHub
gh repo create nix-config --private
git push -u origin main
```

---

**Remember**: After any configuration change, run `rebuild` to apply!

For more examples, check the:
- [NixOS Options Search](https://search.nixos.org/options)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Hyprland Wiki](https://wiki.hyprland.org/)

