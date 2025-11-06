# Minimal Omarchy-Inspired NixOS

A minimal, web-first NixOS configuration inspired by DHH's Omarchy. Features Progressive Web Apps as first-class citizens, keyboard-driven workflow, and Tokyo Night aesthetics.

## Philosophy

- **Web-First**: Web apps behave like native applications
- **Minimal**: ~20 essential packages, single theme, focused tooling
- **Keyboard-Driven**: Optimized shortcuts for productivity
- **Beautiful**: Tokyo Night theme throughout

## Features

### Progressive Web Apps (PWAs)
- Gmail, Calendar, Linear, Notion, and ChatGPT launch as dedicated app windows
- Isolated storage per app (separate cookies/data)
- Auto-organized into workspaces
- Appear in app launcher like native apps
- Launch via `Super+W` menu or direct shortcuts

### Desktop Environment
- **Hyprland**: Modern Wayland compositor
- **Waybar**: Tokyo Night status bar
- **Rofi**: Application launcher
- **Mako**: Notifications
- **Swaylock**: Screen locking

### Tools
- **Browsers**: Firefox (research), Chromium (PWA engine)
- **Editor**: VSCode/Cursor
- **Terminal**: Kitty with Tokyo Night
- **Shell**: Zsh + Starship prompt
- **Essential CLI**: fd, ripgrep, eza

## Quick Start

### Installation

1. Clone this repository:
```bash
git clone <your-repo> ~/code/personal/nix-config
cd ~/code/personal/nix-config
```

2. Update hardware configuration:
```bash
# Generate your hardware config
sudo nixos-generate-config --show-hardware-config > /tmp/hardware.nix
# Copy relevant parts to hosts/helios/hardware.nix
```

3. Customize user settings in:
- `home/emmetdelaney/default.nix` - Update username/home directory
- `home/emmetdelaney/shell.nix` - Update git email

4. Build and switch:
```bash
sudo nixos-rebuild switch --flake .#helios
```

5. Reboot and login to Hyprland

## Keybindings

### Applications
| Key | Action |
|-----|--------|
| `Super + Return` | Terminal |
| `Super + F` | Firefox |
| `Super + E` | Editor (VSCode) |
| `Super + T` | File manager |
| `Super + D` | App launcher |
| `Super + W` | Web apps menu |

### Window Management
| Key | Action |
|-----|--------|
| `Super + Q` | Close window |
| `Super + H/J/K/L` | Focus window (vim keys) |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + Shift + F` | Toggle floating |
| `Super + Shift + M` | Fullscreen |

### Utilities
| Key | Action |
|-----|--------|
| `Super + L` | Lock screen |
| `Print` | Screenshot (area) |
| `Shift + Print` | Screenshot (full) |

## Web Apps

Launch via `Super + W` then select:
- **Gmail** - Email (auto-workspace 1)
- **Calendar** - Calendar (auto-workspace 1)
- **GitHub** - Code hosting (opens in Firefox)
- **Linear** - Project management (auto-workspace 4)
- **Notion** - Notes/wiki (auto-workspace 4)
| **ChatGPT** - AI assistant (auto-workspace 4)

Each PWA launches as a dedicated window with isolated storage.

### Adding Web Apps

Edit `home/emmetdelaney/web-apps.nix`:
```nix
webApps = {
  your-app = {
    name = "YourApp";
    url = "https://your-app.com";
    usePWA = true;  # or false for Firefox
    key = "Y";
  };
};
```

## Workspace Organization (Omarchy-Style)

- **Workspace 1**: Communication (Gmail, Calendar)
- **Workspace 2**: Development (VSCode, Terminal)
- **Workspace 3**: Research (Firefox)
- **Workspace 4**: Planning (Linear, Notion, ChatGPT)

## Customization

### Add Packages
Edit `home/emmetdelaney/packages.nix`:
```nix
home.packages = with pkgs; [
  your-package
];
```

### Modify Keybindings
Edit `home/emmetdelaney/hyprland.nix`:
```nix
bind = [
  "$mod, YourKey, exec, your-command"
];
```

### Change Colors
Tokyo Night colors are inline in `hyprland.nix`. Search for `7aa2f7` (blue) to find and modify.

## System Management

```bash
# Rebuild configuration
rebuild

# Update packages
update

# Clean old generations
cleanup
```

## Project Structure

```
.
├── flake.nix              # Main flake configuration
├── hosts/helios/          # Host-specific config
├── modules/
│   ├── system/           # System modules (boot, network, sound, etc.)
│   └── desktop/          # Desktop (Hyprland, display manager)
└── home/emmetdelaney/    # User configuration
    ├── default.nix       # Main home config
    ├── packages.nix      # Minimal packages
    ├── hyprland.nix      # Hyprland + Tokyo Night theme
    ├── shell.nix         # Zsh configuration
    └── web-apps.nix      # PWA definitions
```

## What's Minimal About This?

| Aspect | This Config | Typical Setup |
|--------|-------------|---------------|
| Packages | ~20 | 100+ |
| Config Files | 8 | 15+ |
| Themes | 1 (Tokyo Night) | Multiple |
| Dev Tools | Git, Editor | Docker, Tmux, Lazygit, etc. |
| Focus | Web productivity | General purpose |

## Backup & Rollback

### Backup
Your current state is tagged as `pre-minimal-backup`:
```bash
git checkout pre-minimal-backup  # Return to pre-minimal state
```

### Rollback
```bash
sudo nixos-rebuild --rollback switch  # Rollback to previous generation
```

## Requirements

- NixOS 25.05 or later
- Understanding of Nix flakes
- Comfort with keyboard-driven workflow
- Willingness to embrace web-first computing

## License

This configuration is provided as-is for personal use.

## Acknowledgments

- Inspired by [DHH's Omarchy](https://world.hey.com/dhh/introducing-omakub-354db366)
- Built with [NixOS](https://nixos.org/)
- Powered by [Hyprland](https://hyprland.org/)
- Themed with Tokyo Night

---

**Enjoy your minimal, web-first NixOS setup!** 🚀