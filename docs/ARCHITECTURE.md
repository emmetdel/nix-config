# NixOS Flake Migration Architecture Plan

## Overview
Migration from traditional NixOS configuration to a modular flake-based system with Hyprland and omarchy-nix theming.

## Current State Analysis

### Existing Configuration
- **System**: NixOS 25.05 (unstable)
- **Hostname**: helios
- **Desktop**: GNOME with GDM
- **Hardware**: AMD CPU, NVMe storage
- **User**: emmetdelaney
- **Packages**: vim, wget, code-cursor, git, zed-editor, vscode-fhs, firefox
- **Key Settings**:
  - Locale: en_GB.UTF-8 with Irish regional settings
  - Timezone: Europe/Dublin
  - Keyboard: GB layout
  - Audio: PipeWire
  - Network: NetworkManager

## Target Architecture

### Project Structure
```
nix-config/
├── flake.nix                    # Main flake entry point
├── flake.lock                   # Flake dependencies lock file
├── hardware-configuration.nix   # Hardware-specific config (preserved)
├── hosts/
│   └── helios/
│       ├── default.nix          # Host-specific configuration
│       └── hardware.nix         # Symlink to ../../hardware-configuration.nix
├── modules/
│   ├── system/
│   │   ├── boot.nix            # Bootloader configuration
│   │   ├── networking.nix       # Network settings
│   │   ├── locale.nix          # Locale and timezone
│   │   └── sound.nix           # Audio configuration
│   └── desktop/
│       ├── hyprland.nix        # Hyprland configuration
│       └── display-manager.nix  # SDDM configuration
└── home/
    └── emmetdelaney/
        ├── default.nix          # Home-manager main config
        ├── packages.nix         # User packages
        └── hyprland.nix         # User Hyprland settings
```

### Flake Inputs

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    omarchy-nix = {
      url = "github:henrysipp/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

## Module Breakdown

### 1. System Modules (`modules/system/`)

#### boot.nix
- Preserve systemd-boot configuration
- EFI variables enabled
- No changes from current setup

#### networking.nix
- Hostname: helios
- NetworkManager enabled
- Firewall configuration (default settings)
- User in networkmanager group

#### locale.nix
- Default locale: en_GB.UTF-8
- Regional settings for Ireland (en_IE.UTF-8)
- Timezone: Europe/Dublin
- Console keymap: uk

#### sound.nix
- PipeWire enabled
- ALSA support with 32-bit
- PulseAudio compatibility layer
- rtkit enabled

### 2. Desktop Modules (`modules/desktop/`)

#### hyprland.nix
**Changes from current**:
- Remove: GNOME, GDM, X11 configuration
- Add: Hyprland with official module
- Add: XWayland support
- Add: Required Wayland packages
- Add: Polkit for authentication

**Configuration**:
```nix
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    wayland
    xwayland
    qt5.qtwayland
    qt6.qtwayland
    
    # Screenshot and screen recording
    grim
    slurp
    wl-clipboard
  ];
}
```

#### display-manager.nix
**Changes from current**:
- Replace GDM with SDDM
- Configure SDDM for Wayland
- Theme integration

### 3. Home Manager Configuration (`home/emmetdelaney/`)

#### default.nix
- Main home-manager configuration
- Imports for packages and Hyprland user settings
- State version: 25.05

#### packages.nix
**Preserved packages**:
- vim
- wget
- code-cursor
- git
- zed-editor
- vscode-fhs
- firefox

**Additional packages for Hyprland**:
- Terminal emulator (kitty or alacritty)
- File manager (thunar or nautilus)
- App launcher (rofi-wayland or wofi)
- Notification daemon (mako or dunst)
- Status bar (waybar)
- Other omarchy dependencies

#### hyprland.nix
- User-specific Hyprland configuration
- Keybindings
- Window rules
- Workspace configuration
- Monitors setup

## Omarchy-nix Integration Strategy

### Integration Method
The omarchy-nix repository provides a complete Hyprland rice configuration. Integration approaches:

1. **Full Import Method** (Recommended)
   - Import omarchy-nix as a flake input
   - Use their provided modules/overlays
   - Apply their configurations via home-manager
   - Customize as needed

2. **Selective Integration**
   - Cherry-pick specific configurations
   - Adapt color schemes and styling
   - Keep custom keybindings

### Expected Omarchy Features
Based on typical omarchy setups:
- **Theme**: Custom color scheme (gruvbox/catppuccin variant)
- **Components**:
  - Waybar (status bar)
  - Rofi (application launcher)
  - Kitty/Alacritty (terminal)
  - Dunst/Mako (notifications)
  - Custom wallpapers
  - GTK/Qt theming
  - Cursor theme
  - Icon theme

## Migration Strategy

### Phase 1: Structure Setup
1. Create directory structure
2. Split current configuration into modules
3. Update flake.nix with all inputs

### Phase 2: System Migration
1. Move system settings to modules
2. Preserve all non-desktop configurations
3. Test system module imports

### Phase 3: Desktop Migration
1. Disable GNOME/GDM
2. Enable Hyprland and SDDM
3. Configure basic Hyprland settings

### Phase 4: Omarchy Integration
1. Add omarchy-nix input to flake
2. Import omarchy configurations
3. Apply theming through home-manager

### Phase 5: User Configuration
1. Set up home-manager with omarchy
2. Preserve user packages
3. Configure user-specific settings

## Compatibility Considerations

### Package Compatibility
All current packages should work with Hyprland:
- **Code editors** (vscode-fhs, code-cursor, zed-editor): ✓ Work with Wayland
- **Firefox**: ✓ Native Wayland support
- **Git, vim, wget**: ✓ Terminal tools, no issues

### Settings Preservation
- **Networking**: No changes needed
- **Audio**: PipeWire works perfectly with Hyprland
- **Printing**: CUPS continues to work
- **Locale/Timezone**: No changes needed
- **User account**: No changes needed

## Risk Mitigation

### Backup Strategy
1. Keep original `configuration.nix` as `configuration.nix.backup`
2. Test in VM or with `nixos-rebuild test` before `switch`
3. Maintain ability to boot into previous generation

### Rollback Plan
```bash
# If issues arise, rollback to previous generation
sudo nixos-rebuild --rollback switch

# Or select previous generation in boot menu
```

### Testing Approach
```bash
# Test build without switching
sudo nixos-rebuild build --flake .#helios

# Test with temporary activation
sudo nixos-rebuild test --flake .#helios

# Only switch when confirmed working
sudo nixos-rebuild switch --flake .#helios
```

## Post-Migration Tasks

### Essential First Boot
1. Log into Hyprland session via SDDM
2. Verify basic functionality:
   - Terminal launches (Super+Return or configured key)
   - Application launcher works
   - Network connectivity
   - Audio output
3. Install any missing packages via home-manager

### Customization
1. Adjust Hyprland keybindings if needed
2. Configure monitors and workspaces
3. Customize omarchy theme colors
4. Set up preferred applications

## Benefits of New Structure

### Modularity
- Clear separation of concerns
- Easy to enable/disable features
- Reusable across multiple hosts

### Maintainability
- Smaller, focused configuration files
- Easier to understand and modify
- Better git history tracking

### Reproducibility
- Locked flake inputs ensure consistency
- Easy to deploy to new machines
- Declarative user environment with home-manager

### Aesthetics
- Modern, cohesive design with omarchy
- Tiling window manager efficiency
- Beautiful, customizable interface

## Next Steps

Once you approve this architecture:
1. Switch to Code mode to implement the structure
2. Create all necessary files and directories
3. Migrate configurations module by module
4. Test the build
5. Provide rebuild instructions

## Questions?

Before proceeding, please confirm:
- ✓ You're comfortable replacing GNOME with Hyprland
- ✓ You understand this requires learning tiling WM keybindings
- ✓ You approve the modular structure proposed
- ✓ You want to proceed with full omarchy-nix integration