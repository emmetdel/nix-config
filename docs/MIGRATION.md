# NixOS Flake Migration Guide

## Pre-Migration Checklist

### Before You Begin

- [ ] **Backup current configuration**
  ```bash
  cp /etc/nixos/configuration.nix ~/configuration.nix.backup
  cp /etc/nixos/hardware-configuration.nix ~/hardware-configuration.nix.backup
  ```

- [ ] **Ensure you can access a terminal from the login screen**
  - Know how to access TTY (Ctrl+Alt+F2)
  - Have root password available

- [ ] **Verify current system is working**
  ```bash
  sudo nixos-rebuild test
  ```

- [ ] **Update current system before migration**
  ```bash
  sudo nixos-rebuild switch --upgrade
  ```

- [ ] **Commit current state to git** (if using version control)
  ```bash
  cd ~/code/personal/nix-config
  git add -A
  git commit -m "Pre-migration backup"
  ```

- [ ] **Free up disk space**
  ```bash
  nix-collect-garbage -d
  sudo nix-collect-garbage -d
  ```

- [ ] **Ensure experimental features are enabled** (already done in your config)
  - Check: `nix.settings.experimental-features = [ "nix-command" "flakes" ];`

### System Information

Current configuration location: `/home/emmetdelaney/code/personal/nix-config`

**Key Settings to Preserve**:
- Hostname: helios
- User: emmetdelaney
- Timezone: Europe/Dublin
- Locale: en_GB.UTF-8 with Irish regional
- Keyboard: GB layout
- Packages: vim, wget, code-cursor, git, zed-editor, vscode-fhs, firefox

## Migration Steps

### Step 1: Create Directory Structure

```bash
cd ~/code/personal/nix-config

# Create module directories
mkdir -p modules/system
mkdir -p modules/desktop
mkdir -p hosts/helios
mkdir -p home/emmetdelaney
```

### Step 2: Create System Modules

These files will contain your existing system configuration, split into logical modules.

#### Create `modules/system/boot.nix`

This preserves your bootloader settings:
- systemd-boot enabled
- EFI variables accessible

#### Create `modules/system/networking.nix`

This preserves:
- Hostname: helios
- NetworkManager
- Experimental features for flakes

#### Create `modules/system/locale.nix`

This preserves:
- Timezone: Europe/Dublin
- Locale: en_GB.UTF-8
- Irish regional settings
- GB keyboard layout

#### Create `modules/system/sound.nix`

This preserves:
- PipeWire configuration
- PulseAudio compatibility
- ALSA support

### Step 3: Create Desktop Modules

These replace GNOME with Hyprland.

#### Create `modules/desktop/hyprland.nix`

**Major Change**: Enables Hyprland instead of GNOME
- Hyprland with XWayland
- Essential Wayland packages
- Omarchy theme integration

#### Create `modules/desktop/display-manager.nix`

**Major Change**: Replaces GDM with SDDM
- SDDM for Wayland
- Configured for Hyprland

### Step 4: Create Host Configuration

#### Create `hosts/helios/default.nix`

This file imports all modules and configures home-manager.

#### Create `hosts/helios/hardware.nix`

```bash
cd ~/code/personal/nix-config/hosts/helios
ln -s ../../hardware-configuration.nix hardware.nix
```

### Step 5: Create Home-Manager Configuration

#### Create `home/emmetdelaney/default.nix`

Main home-manager configuration file.

#### Create `home/emmetdelaney/packages.nix`

Preserves all your current packages:
- vim, wget, git
- code-cursor, zed-editor, vscode-fhs
- firefox

Adds Hyprland essentials:
- Terminal emulator
- File manager
- App launcher

#### Create `home/emmetdelaney/hyprland.nix`

User-specific Hyprland configuration:
- Keybindings
- Window rules
- Startup apps

### Step 6: Update flake.nix

Replace your existing flake.nix with the new one that includes:
- Hyprland input
- Omarchy-nix input
- Updated module imports

### Step 7: Initial Build Test

Before switching, test the build:

```bash
cd ~/code/personal/nix-config

# Test build without activating
sudo nixos-rebuild build --flake .#helios
```

**If build fails**:
1. Check error messages
2. Review syntax in new files
3. Ensure all imports are correct
4. Fix issues and retry

### Step 8: Test Activation

Once build succeeds, test activation:

```bash
# Test activation without making it permanent
sudo nixos-rebuild test --flake .#helios
```

This activates the new config temporarily. If something breaks, just reboot to go back.

**Test checklist**:
- [ ] System boots
- [ ] Can access TTY (Ctrl+Alt+F2)
- [ ] Network connection works
- [ ] Can log in as user

### Step 9: Switch to New Configuration

If testing went well:

```bash
# Make it permanent
sudo nixos-rebuild switch --flake .#helios
```

### Step 10: Reboot and First Login

```bash
sudo reboot
```

**At SDDM login screen**:
1. Select Hyprland as session (dropdown menu)
2. Enter password
3. Log in

## First Boot into Hyprland

### Essential Keybindings (Default Hyprland)

**Note**: These may be customized by omarchy-nix. Check the omarchy documentation.

- `SUPER + Q`: Close active window
- `SUPER + Return`: Open terminal
- `SUPER + D`: Application launcher
- `SUPER + M`: Exit Hyprland
- `SUPER + V`: Toggle floating
- `SUPER + F`: Toggle fullscreen
- `SUPER + 1-9`: Switch to workspace
- `SUPER + Shift + 1-9`: Move window to workspace
- `SUPER + Mouse`: Move/resize windows

### Verify Functionality

- [ ] **Terminal opens**: Press `SUPER + Return`
- [ ] **Network works**: Run `ping google.com` in terminal
- [ ] **Audio works**: Test with any media
- [ ] **Applications launch**: Try opening Firefox
- [ ] **Packages available**: Check `vim`, `git`, `code-cursor`, etc.

### Common First-Boot Issues

#### No terminal opens
**Solution**: Press `Ctrl+Alt+F2` to access TTY, then:
```bash
# Install default terminal if missing
nix-shell -p kitty --run kitty
```

#### Application launcher doesn't work
**Solution**: Check if rofi/wofi is installed:
```bash
which rofi
which wofi
```

#### Display issues
**Solution**: Check monitor configuration in Hyprland config

## Rollback Procedures

### If Something Goes Wrong

#### Option 1: Boot Previous Generation

1. Reboot the system
2. At boot menu, select previous generation
3. System boots with old configuration

#### Option 2: Command-Line Rollback

```bash
# From TTY or terminal
sudo nixos-rebuild --rollback switch
```

#### Option 3: Restore from Backup

```bash
# Copy backup back
sudo cp ~/configuration.nix.backup /etc/nixos/configuration.nix
sudo cp ~/hardware-configuration.nix.backup /etc/nixos/hardware-configuration.nix

# Rebuild with old config
sudo nixos-rebuild switch
```

## Post-Migration Tasks

### 1. Update flake.lock

```bash
cd ~/code/personal/nix-config
nix flake update
sudo nixos-rebuild switch --flake .#helios
```

### 2. Customize Hyprland

Edit `home/emmetdelaney/hyprland.nix`:
- Adjust keybindings to your preference
- Configure monitor layout
- Set workspace rules
- Add startup applications

### 3. Customize Omarchy Theme

Check omarchy-nix documentation for:
- Color scheme customization
- Wallpaper changes
- Bar configuration
- Icon/cursor themes

### 4. Install Additional Packages

Add to `home/emmetdelaney/packages.nix`:
```nix
home.packages = with pkgs; [
  # Your existing packages
  vim
  wget
  # ... etc
  
  # Add new packages here
  # htop
  # neofetch
];
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#helios
```

### 5. Configure Applications

Some applications may need Wayland-specific configuration:

**VSCode/Cursor/Zed**:
- Should work out of the box with Wayland
- If issues, can force X11 with specific flags

**Firefox**:
- Should auto-detect Wayland
- To verify: `about:support` → check Window Protocol

### 6. Set Up Workspace Workflow

Configure in `home/emmetdelaney/hyprland.nix`:
```nix
# Example workspace rules
workspace = 1, monitor:eDP-1, default:true
workspace = 2, monitor:eDP-1
# etc.

# Window rules for specific apps
windowrule = workspace 1, firefox
windowrule = workspace 2, code-cursor
```

## Maintenance Commands

### Update System

```bash
cd ~/code/personal/nix-config

# Update flake inputs
nix flake update

# Rebuild with updates
sudo nixos-rebuild switch --flake .#helios
```

### Update Specific Input

```bash
# Update only nixpkgs
nix flake lock --update-input nixpkgs

# Update only omarchy-nix
nix flake lock --update-input omarchy-nix
```

### Garbage Collection

```bash
# Clean old generations (keep last 5)
sudo nix-collect-garbage --delete-older-than 5d

# Or clean everything except current
sudo nix-collect-garbage -d
```

### List Generations

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Rebuild Without Switching

```bash
# Just build (no activation)
sudo nixos-rebuild build --flake .#helios

# Build and test (temporary activation)
sudo nixos-rebuild test --flake .#helios

# Build and switch (permanent)
sudo nixos-rebuild switch --flake .#helios
```

## Troubleshooting

### Build Errors

**Syntax errors in .nix files**:
- Check for missing semicolons
- Ensure proper bracket matching
- Verify attribute names

**Module not found**:
- Check import paths
- Ensure files exist
- Verify module is imported in `hosts/helios/default.nix`

**Package not found**:
- Check package name: `nix search nixpkgs <package>`
- Ensure nixpkgs input is correct version

### Runtime Issues

**Display not working**:
- Check Hyprland logs: `journalctl -u display-manager`
- Verify monitor configuration
- Try different display manager backend

**Audio not working**:
- Check PipeWire status: `systemctl --user status pipewire`
- Restart PipeWire: `systemctl --user restart pipewire`

**Network not working**:
- Check NetworkManager: `systemctl status NetworkManager`
- Reconnect: `nmcli device wifi connect <SSID>`

**Applications not starting**:
- Check from terminal for error messages
- Verify package is installed: `which <app>`
- Check if Wayland-compatible

### Hyprland-Specific Issues

**Black screen after login**:
1. Press `Ctrl+Alt+F2` for TTY
2. Check Hyprland logs: `journalctl -xe | grep hyprland`
3. Verify GPU drivers are loaded

**Keybindings not working**:
- Check `home/emmetdelaney/hyprland.nix` for conflicts
- Verify omarchy keybindings don't clash

**Screen tearing**:
- Adjust Hyprland settings in config
- Enable VRR if supported

## Advanced Topics

### Adding a New Host

To add another machine:

1. Create `hosts/<hostname>/default.nix`
2. Create `hosts/<hostname>/hardware.nix`
3. Add to `flake.nix` under `nixosConfigurations`
4. Build: `sudo nixos-rebuild switch --flake .#<hostname>`

### Sharing Configuration Between Hosts

Create common modules in `modules/` and import them in multiple hosts.

### Using Different Desktop on Another Host

Create `modules/desktop/gnome.nix` and import it instead of Hyprland in that host's config.

### Per-User Configuration

Add more users under `home/`:
```
home/
├── emmetdelaney/
└── another-user/
```

Configure in `hosts/helios/default.nix`.

## Expected Differences After Migration

### Visual Changes
- **Before**: GNOME desktop with traditional GUI
- **After**: Hyprland tiling window manager with omarchy aesthetics

### Workflow Changes
- **Before**: Click-based workflow
- **After**: Keyboard-driven tiling workflow

### Login Screen
- **Before**: GDM
- **After**: SDDM

### What Stays the Same
- All your packages and applications
- Network settings
- Audio configuration
- System settings (locale, timezone, keyboard)
- User account and files

## Getting Help

### Resources
- **Hyprland Wiki**: https://wiki.hyprland.org
- **Hyprland GitHub**: https://github.com/hyprwm/Hyprland
- **Omarchy-nix**: https://github.com/henrysipp/omarchy-nix
- **NixOS Wiki**: https://nixos.wiki
- **Home-Manager Manual**: https://nix-community.github.io/home-manager/

### Community
- NixOS Discourse: https://discourse.nixos.org
- r/NixOS: https://reddit.com/r/NixOS
- Hyprland Discord: Check Hyprland GitHub for invite

## Summary

This migration:
1. ✅ Preserves all your current system settings
2. ✅ Keeps all your installed packages
3. ✅ Organizes configuration into modular structure
4. ✅ Replaces GNOME with Hyprland
5. ✅ Integrates omarchy-nix theming
6. ✅ Uses flakes for reproducibility
7. ✅ Sets up home-manager for user config

You'll have a modern, modular NixOS configuration with a beautiful Hyprland setup!