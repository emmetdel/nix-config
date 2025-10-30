# NixOS Omarchy Configuration

A modern, opinionated NixOS configuration inspired by DHH's Omarchy, featuring Hyprland, comprehensive theming, and developer-focused tools.

## 🌟 Features

### Core Components
- **Hyprland**: Modern Wayland compositor with beautiful animations
- **Home Manager**: Declarative user environment management
- **Nix Flakes**: Reproducible and portable configuration
- **Multiple Themes**: Tokyo Night, Catppuccin, Nord, Gruvbox

### Desktop Environment
- **Status Bar**: Waybar with system information
- **Notifications**: Mako notification daemon
- **Application Launcher**: Rofi with custom theming
- **Screen Lock**: Swaylock with auto-lock via Swayidle
- **Clipboard Manager**: Cliphist with history
- **Color Picker**: Hyprpicker for color selection

### Developer Tools
- **Shell**: Zsh with Starship prompt
- **Editor**: Neovim with sensible defaults
- **Terminal**: Kitty with transparency and theming
- **Git**: Comprehensive configuration with Delta diffs
- **GitHub CLI**: Integrated with SSH
- **Tmux**: Terminal multiplexer with vim bindings
- **Lazygit**: Beautiful terminal UI for Git

### Productivity Tools
- **File Managers**: Thunar (GUI), Yazi (Terminal)
- **System Monitor**: btop, htop
- **Password Manager**: Bitwarden CLI
- **Container Tools**: Docker, Podman, Docker Compose
- **Web Apps Launcher**: Quick access to common web applications
- **Screenshot Tools**: Grim, Slurp, Swappy

### Modern CLI Tools
- **fd**: Better find
- **ripgrep**: Better grep
- **eza**: Better ls with icons
- **bat**: Better cat with syntax highlighting
- **fzf**: Fuzzy finder
- **zoxide**: Smart directory navigation
- **direnv**: Per-directory environment management

## 📦 Installation

### Prerequisites
- A machine running NixOS or ready for NixOS installation
- Basic familiarity with Nix and NixOS

### Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/nix-config.git ~/personal-code/nix-config
   cd ~/personal-code/nix-config
   ```

2. **Customize for your system**:
   - Edit `hosts/helios/hardware.nix` with your hardware configuration
   - Update user information in `modules/system/users.nix`
   - Adjust `home/emmetdelaney/default.nix` with your username/home directory

3. **Build and activate**:
   ```bash
   sudo nixos-rebuild switch --flake .#helios
   ```

4. **Set up Git credentials**:
   ```bash
   gh auth login
   ```

5. **Optional: Set a wallpaper**:
   ```bash
   cp your-wallpaper.jpg ~/.config/wallpaper.jpg
   ```

## ⌨️ Keybindings

### General
| Keybinding | Action |
|------------|--------|
| `Super + Return` | Launch terminal (Kitty) |
| `Super + D` | Application launcher (Rofi) |
| `Super + R` | Run command |
| `Super + Q` | Close active window |
| `Super + M` | Exit Hyprland |
| `Super + F` | Toggle fullscreen |
| `Super + V` | Toggle floating |
| `Super + L` | Lock screen |

### Applications
| Keybinding | Action |
|------------|--------|
| `Super + E` | File manager (Thunar) |
| `Super + Shift + E` | Terminal file manager (Yazi) |
| `Super + Shift + B` | Browser (Firefox) |
| `Super + Shift + C` | Code editor (VSCode/Cursor) |
| `Super + W` | Web apps launcher |

### Utilities
| Keybinding | Action |
|------------|--------|
| `Super + Shift + V` | Clipboard history |
| `Super + C` | Color picker |
| `Print` | Screenshot area |
| `Shift + Print` | Screenshot full screen |

### Window Management
| Keybinding | Action |
|------------|--------|
| `Super + H/J/K/L` | Move focus (Vim keys) |
| `Super + Arrow Keys` | Move focus |
| `Super + 1-9,0` | Switch to workspace |
| `Super + Shift + 1-9,0` | Move window to workspace |
| `Super + S` | Toggle scratchpad |
| `Super + Shift + S` | Move to scratchpad |
| `Super + Mouse Left` | Move window |
| `Super + Mouse Right` | Resize window |

### Tmux (Terminal Multiplexer)
| Keybinding | Action |
|------------|--------|
| `Ctrl + A` | Tmux prefix key |
| `Prefix + \|` | Split vertical |
| `Prefix + -` | Split horizontal |
| `Prefix + H/J/K/L` | Navigate panes |
| `Prefix + R` | Reload config |

## 🎨 Theming

The configuration includes four built-in themes:

1. **Tokyo Night** (default) - Dark blue with vibrant accents
2. **Catppuccin Mocha** - Warm, pastel dark theme
3. **Nord** - Cool, arctic-inspired palette
4. **Gruvbox** - Retro, warm color scheme

### Changing Themes

Edit `home/emmetdelaney/themes.nix` and change the `activeTheme` variable:

```nix
# Select the active theme
activeTheme = themes.catppuccin-mocha;  # or nord, gruvbox
```

Then rebuild:
```bash
rebuild
```

The theme will automatically apply to:
- Terminal (Kitty)
- Waybar
- Rofi
- Mako notifications
- Hyprland borders and shadows
- GTK/Qt applications

## 🔧 Customization

### Adding Packages

Add user packages in `home/emmetdelaney/packages.nix`:
```nix
home.packages = with pkgs; [
  your-package-here
];
```

Add system packages in `hosts/helios/default.nix`:
```nix
environment.systemPackages = with pkgs; [
  your-system-package
];
```

### Modifying Hyprland

Edit `home/emmetdelaney/hyprland.nix` to customize:
- Keybindings
- Window rules
- Animations
- Decorations
- Monitor configuration

### Shell Customization

Edit `home/emmetdelaney/shell.nix` to modify:
- Aliases
- Prompt configuration
- Shell integrations
- Environment variables

### Adding Web Apps

Edit the web-apps script in `home/emmetdelaney/utilities.nix`:
```nix
apps=(
  "YourApp:https://yourapp.com"
  ...
)
```

## 📁 Project Structure

```
.
├── flake.nix              # Main flake configuration
├── hosts/
│   └── helios/
│       ├── default.nix    # Host-specific configuration
│       └── hardware.nix   # Hardware configuration
├── modules/
│   ├── system/            # System-level modules
│   │   ├── boot.nix
│   │   ├── locale.nix
│   │   ├── networking.nix
│   │   ├── sound.nix
│   │   ├── users.nix
│   │   └── virtualization.nix
│   └── desktop/           # Desktop environment modules
│       ├── hyprland.nix
│       └── display-manager.nix
└── home/
    └── emmetdelaney/      # User configuration
        ├── default.nix    # Main home configuration
        ├── packages.nix   # User packages
        ├── hyprland.nix   # Hyprland user config
        ├── shell.nix      # Shell configuration
        ├── dev-tools.nix  # Developer tools
        ├── themes.nix     # Theming system
        └── utilities.nix  # Utility scripts and services
```

## 🚀 Quick Commands

Added convenient aliases in your shell:

```bash
rebuild      # Rebuild and switch NixOS configuration
update       # Update flake inputs
cleanup      # Clean up old generations
g            # Git shorthand
gs           # Git status
ll           # List files with icons
tree         # Show directory tree
cat          # Syntax-highlighted cat (bat)
```

## 🔐 Password Management

This configuration includes Bitwarden CLI for password management:

```bash
# Login to Bitwarden
bw login

# Unlock vault
bw unlock

# Get password
bw get password github.com
```

For GUI password management, consider installing:
```bash
# Add to packages.nix
bitwarden
```

## 🐳 Container Development

Docker and Podman are pre-configured:

```bash
# Using Docker
docker run hello-world
docker-compose up

# Using Podman (Docker-compatible)
podman run hello-world
podman-compose up
```

## 📚 Additional Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

## 🤝 Contributing

Feel free to fork this configuration and adapt it to your needs. Pull requests for improvements are welcome!

## 📝 License

This configuration is provided as-is for personal and educational use.

## 🙏 Acknowledgments

- Inspired by DHH's [Omarchy](https://github.com/basecamp/omarchy)
- Built with [NixOS](https://nixos.org/)
- Powered by [Hyprland](https://hyprland.org/)
- Themed with inspiration from Tokyo Night, Catppuccin, Nord, and Gruvbox

---

**Enjoy your beautiful, reproducible NixOS setup!** ✨
