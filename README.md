# NixOS Flake Configuration with Hyprland & Omarchy

This repository contains a modular, flake-based NixOS configuration for the "helios" system, featuring Hyprland window manager with omarchy-nix theming.

## 📋 Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Detailed architecture design and rationale
- **[STRUCTURE.md](STRUCTURE.md)** - Project structure and component relationships
- **[MIGRATION.md](MIGRATION.md)** - Step-by-step migration guide with troubleshooting
- **[IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md)** - Implementation checklist and timeline

## 🎯 Overview

### Current Setup
- **Desktop**: GNOME with GDM
- **Packages**: vim, wget, code-cursor, git, zed-editor, vscode-fhs, firefox
- **Configuration**: Single `configuration.nix` file

### Target Setup
- **Desktop**: Hyprland (tiling Wayland compositor) with SDDM
- **Theme**: omarchy-nix aesthetic
- **Packages**: All current packages preserved + Hyprland essentials
- **Configuration**: Modular flake-based structure

## 📁 Project Structure

```
nix-config/
├── flake.nix                    # Main flake entry point
├── flake.lock                   # Flake dependencies
├── hardware-configuration.nix   # Hardware config (preserved)
│
├── hosts/helios/                # Host-specific configuration
│   ├── default.nix
│   └── hardware.nix
│
├── modules/                     # Reusable modules
│   ├── system/                  # System configuration
│   │   ├── boot.nix
│   │   ├── networking.nix
│   │   ├── locale.nix
│   │   └── sound.nix
│   └── desktop/                 # Desktop environment
│       ├── hyprland.nix
│       └── display-manager.nix
│
└── home/emmetdelaney/          # User configuration
    ├── default.nix
    ├── packages.nix
    └── hyprland.nix
```

## 🚀 Quick Start (After Implementation)

### Rebuild System
```bash
sudo nixos-rebuild switch --flake .#helios
```

### Update Flake Inputs
```bash
nix flake update
sudo nixos-rebuild switch --flake .#helios
```

### Test Without Switching
```bash
sudo nixos-rebuild test --flake .#helios
```

### Rollback to Previous Generation
```bash
sudo nixos-rebuild --rollback switch
```

## 🔑 Key Features

### Modular Design
- Clear separation between system, desktop, and user configurations
- Easy to add new hosts or users
- Reusable modules across different machines

### Preserved Settings
- ✅ All current packages
- ✅ Locale and timezone settings (en_GB.UTF-8, Europe/Dublin)
- ✅ Network configuration (NetworkManager)
- ✅ Audio setup (PipeWire)
- ✅ User account and groups
- ✅ Hardware configuration

### New Features
- ✨ Hyprland tiling window manager
- ✨ Omarchy-nix aesthetic theme
- ✨ Flake-based reproducible builds
- ✨ Home-manager for user configuration
- ✨ SDDM display manager

## 📦 Flake Inputs

- **nixpkgs**: NixOS unstable channel
- **home-manager**: User environment management
- **hyprland**: Hyprland window manager
- **omarchy-nix**: Omarchy theme and configurations

## ⚙️ System Specifications

- **Hostname**: helios
- **User**: emmetdelaney
- **Hardware**: AMD CPU, NVMe storage
- **Locale**: en_GB.UTF-8 with Irish regional settings
- **Timezone**: Europe/Dublin
- **Keyboard**: GB layout
- **Audio**: PipeWire with PulseAudio compatibility

## 🎨 Hyprland Basics

### Essential Keybindings (Default)
- `SUPER + Q` - Close window
- `SUPER + Return` - Open terminal
- `SUPER + D` - Application launcher
- `SUPER + M` - Exit Hyprland
- `SUPER + 1-9` - Switch workspace
- `SUPER + Shift + 1-9` - Move window to workspace

*Note: Omarchy-nix may customize these keybindings.*

## 🛠️ Customization

### Add Packages
Edit `home/emmetdelaney/packages.nix`:
```nix
home.packages = with pkgs; [
  vim
  wget
  # Add your packages here
];
```

### Modify Hyprland Settings
Edit `home/emmetdelaney/hyprland.nix` for user-specific settings or `modules/desktop/hyprland.nix` for system-wide settings.

### Change System Settings
Edit appropriate modules in `modules/system/` or `modules/desktop/`.

## 🔄 Migration Status

### ✅ Planning Complete
- [x] Architecture designed
- [x] Structure documented
- [x] Migration guide created
- [x] Implementation plan ready

### ⏳ Pending Implementation
- [ ] Create directory structure
- [ ] Write all module files
- [ ] Update flake.nix
- [ ] Test build
- [ ] Deploy configuration

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home-Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Omarchy-nix Repository](https://github.com/henrysipp/omarchy-nix)
- [NixOS Wiki](https://nixos.wiki/)

## ⚠️ Important Notes

### Before Migration
1. Read [MIGRATION.md](MIGRATION.md) completely
2. Backup your current configuration
3. Ensure you can access TTY (Ctrl+Alt+F2)
4. Have root password available

### After Migration
1. Learn basic Hyprland keybindings
2. Customize settings to your preference
3. Update flake regularly for security patches
4. Keep at least one old generation for rollback

## 🆘 Troubleshooting

### Build Fails
Check syntax of all .nix files and review error messages in build output.

### Hyprland Won't Start
Access TTY (Ctrl+Alt+F2) and check logs: `journalctl -xe | grep hyprland`

### Need to Rollback
At boot menu, select previous generation, or run: `sudo nixos-rebuild --rollback switch`

For detailed troubleshooting, see [MIGRATION.md](MIGRATION.md).

## 📝 License

This configuration is for personal use. Feel free to adapt it for your own systems.

## 🙏 Acknowledgments

- [Hyprland](https://github.com/hyprwm/Hyprland) - Amazing Wayland compositor
- [Omarchy-nix](https://github.com/henrysipp/omarchy-nix) - Beautiful theme
- NixOS Community - For excellent documentation and support