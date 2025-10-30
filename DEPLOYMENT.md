# Deployment Instructions

## ✅ Pre-Deployment Status

Your NixOS flake migration is **complete and tested**! All files have been created, the configuration passes validation, and you're ready to deploy.

### What's Been Done

✅ Created modular directory structure  
✅ Split configuration into logical modules  
✅ Configured Hyprland window manager  
✅ Set up SDDM display manager  
✅ Integrated omarchy-nix theming  
✅ Configured home-manager for user settings  
✅ Preserved all your packages and settings  
✅ Backed up original configuration  
✅ Validated flake configuration (no errors!)

## 📋 Deployment Steps

### Step 1: Review Your Configuration

Before deploying, take a moment to review key files:

```bash
# View the main flake configuration
cat flake.nix

# View your host configuration
cat hosts/helios/default.nix

# View your user packages
cat home/emmetdelaney/packages.nix
```

**Important**: Update your git email in [`home/emmetdelaney/default.nix`](home/emmetdelaney/default.nix:27) if needed (currently set to `emmetdel@gmail.com`).

### Step 2: Commit Your Changes

Since flakes require files to be tracked by git:

```bash
# Stage all new files
git add .

# Commit the migration
git commit -m "Migrate to modular flake-based config with Hyprland and omarchy-nix"
```

### Step 3: Test Build (Recommended)

Build the new system without activating it:

```bash
sudo nixos-rebuild build --flake .#helios
```

This creates the system closure but doesn't activate it. If successful, you'll see the build output without errors.

### Step 4: Test Activation (Optional but Recommended)

Temporarily activate the new configuration without making it permanent:

```bash
sudo nixos-rebuild test --flake .#helios
```

**What happens**: The new configuration is activated but won't persist after reboot. This is perfect for testing.

**Important**: After running `test`, you'll still be in your current GNOME session. The changes will take effect on next login/reboot.

### Step 5: Deploy the New Configuration

When you're ready to make it permanent:

```bash
sudo nixos-rebuild switch --flake .#helios
```

**What happens**: 
- New system configuration is built
- New generation is added to boot menu
- System services are restarted as needed
- Changes take effect immediately

### Step 6: Reboot

```bash
sudo reboot
```

## 🎯 First Boot with Hyprland

### At the SDDM Login Screen

1. **Select Session**: Click the session dropdown (usually top-right or bottom-left)
2. **Choose Hyprland**: Select "Hyprland" from the list
3. **Enter Password**: Type your password
4. **Login**: Press Enter

### First Actions in Hyprland

Once logged in, you'll see a minimal desktop. Here's what to do:

#### 1. Open a Terminal
Press `SUPER + Return` (Super is the Windows key)

This should open Kitty terminal.

#### 2. Verify Basic Functionality

In the terminal, run:
```bash
# Check network
ping -c 3 google.com

# Check audio (should show PipeWire)
pactl info

# Verify your packages are available
which firefox
which code-cursor
which zed-editor
```

#### 3. Open Application Launcher
Press `SUPER + D` to open Rofi application launcher

Type to search for applications and press Enter to launch.

#### 4. Test Applications

Try opening some applications:
- Firefox: Search in Rofi or run `firefox` in terminal
- File Manager: Press `SUPER + E` or search for "Thunar" in Rofi
- Code Editor: Search for your preferred editor in Rofi

## 🔑 Essential Hyprland Keybindings

| Keybinding | Action |
|------------|--------|
| `SUPER + Return` | Open terminal (Kitty) |
| `SUPER + Q` | Close active window |
| `SUPER + D` | Application launcher (Rofi) |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + V` | Toggle floating |
| `SUPER + M` | Exit Hyprland |
| `SUPER + 1-9` | Switch to workspace 1-9 |
| `SUPER + SHIFT + 1-9` | Move window to workspace 1-9 |
| `SUPER + Mouse Left` | Move window |
| `SUPER + Mouse Right` | Resize window |
| `Print` | Screenshot (select area) |
| `SHIFT + Print` | Screenshot (full screen) |

## 🎨 What You'll See

### Visual Elements

- **Waybar**: Status bar at the top showing workspaces, window title, time, volume, network, battery
- **Rounded Windows**: 10px border radius on all windows
- **Window Gaps**: 5px inner gaps, 10px outer gaps
- **Blur Effect**: Subtle blur on transparent elements
- **Animations**: Smooth window animations
- **Notifications**: Mako notification daemon (top-right corner)

### Default Applications

- **Terminal**: Kitty with Tokyo Night theme and transparent background
- **Launcher**: Rofi with application icons
- **File Manager**: Thunar with useful plugins
- **Screenshot**: Grim + Slurp (select region to capture)

## 🔧 Customization

### Change Hyprland Settings

Edit [`home/emmetdelaney/hyprland.nix`](home/emmetdelaney/hyprland.nix:1):

```bash
vim home/emmetdelaney/hyprland.nix
# Or use your preferred editor
```

After changes, rebuild:
```bash
sudo nixos-rebuild switch --flake .#helios
```

### Add Packages

Edit [`home/emmetdelaney/packages.nix`](home/emmetdelaney/packages.nix:1):

```nix
home.packages = with pkgs; [
  # Your existing packages
  vim
  wget
  # ... etc

  # Add new packages here
  htop
  discord
  # etc
];
```

Rebuild to install:
```bash
sudo nixos-rebuild switch --flake .#helios
```

### Change Keybindings

In [`home/emmetdelaney/hyprland.nix`](home/emmetdelaney/hyprland.nix:89), find the `bind` section:

```nix
bind = [
  "$mod, Return, exec, kitty"
  # Modify or add new keybindings here
];
```

### Adjust Colors/Theme

The current setup uses a blue/cyan accent theme. To change colors:

1. Edit border colors in [`home/emmetdelaney/hyprland.nix`](home/emmetdelaney/hyprland.nix:35)
2. Edit Waybar colors in [`home/emmetdelaney/hyprland.nix`](home/emmetdelaney/hyprland.nix:219)
3. Edit Mako notification colors in [`home/emmetdelaney/hyprland.nix`](home/emmetdelaney/hyprland.nix:243)

## 🚨 Troubleshooting

### Hyprland Won't Start

**Symptoms**: Black screen or returns to login after entering password

**Solution**:
1. Press `Ctrl + Alt + F2` to access TTY
2. Login with your username and password
3. Check logs: `journalctl -xe | grep hyprland`
4. Try rebuilding: `sudo nixos-rebuild switch --flake .#helios`

### No Terminal Opens

**Symptoms**: Pressing `SUPER + Return` does nothing

**Solution**:
1. Press `Ctrl + Alt + F2` for TTY
2. Check if Kitty is installed: `which kitty`
3. Try launching manually: `kitty` (if in graphical session)
4. Rebuild if needed: `sudo nixos-rebuild switch --flake .#helios`

### Application Launcher Not Working

**Symptoms**: Pressing `SUPER + D` does nothing

**Solution**:
1. Open terminal (`SUPER + Return`)
2. Run `rofi -show drun` manually to test
3. Check if rofi is installed: `which rofi`
4. Rebuild if needed

### Audio Not Working

**Symptoms**: No sound output

**Solution**:
```bash
# Check PipeWire status
systemctl --user status pipewire

# Restart PipeWire
systemctl --user restart pipewire

# Open audio control
pavucontrol
```

### Network Issues

**Symptoms**: No internet connection

**Solution**:
```bash
# Check NetworkManager
systemctl status NetworkManager

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Connect to WiFi
nmcli device wifi connect "YOUR_SSID" password "YOUR_PASSWORD"
```

### Want to Go Back?

**Option 1: Boot Previous Generation**
1. Reboot your system
2. At the boot menu, select a previous generation
3. Your old GNOME setup will be there

**Option 2: Rollback Command**
```bash
sudo nixos-rebuild --rollback switch
```

**Option 3: Restore from Backup**
```bash
sudo cp configuration.nix.backup /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

## 📊 System Information

### Configuration Location
`/home/emmetdelaney/code/personal/nix-config`

### Important Files
- [`flake.nix`](flake.nix:1) - Main flake configuration
- [`flake.lock`](flake.lock:1) - Locked dependencies (auto-generated)
- [`hosts/helios/default.nix`](hosts/helios/default.nix:1) - Host configuration
- [`home/emmetdelaney/`](home/emmetdelaney) - Your user configuration

### Backup Location
`configuration.nix.backup` - Your original configuration

## 🔄 Updating Your System

### Update Everything
```bash
cd ~/code/personal/nix-config
nix flake update
sudo nixos-rebuild switch --flake .#helios
```

### Update Specific Input
```bash
# Update only nixpkgs
nix flake lock --update-input nixpkgs

# Update only Hyprland
nix flake lock --update-input hyprland

# Update only omarchy-nix
nix flake lock --update-input omarchy-nix
```

### Clean Old Generations
```bash
# Delete generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

# Delete all old generations (keep current)
sudo nix-collect-garbage -d
```

## 📚 Next Steps

1. **Explore Hyprland**: Get comfortable with tiling window management
2. **Customize Keybindings**: Adjust to your workflow
3. **Try Omarchy Theming**: Explore the omarchy-nix features
4. **Add Your Packages**: Install any missing applications
5. **Configure Monitors**: If using multiple displays, configure in Hyprland config
6. **Set Wallpaper**: Add your preferred wallpaper (consider using `swaybg` or `hyprpaper`)

## 🎓 Learning Resources

- **Hyprland Wiki**: https://wiki.hyprland.org
- **Hyprland GitHub**: https://github.com/hyprwm/Hyprland
- **NixOS Manual**: https://nixos.org/manual/nixos/stable/
- **Home-Manager Manual**: https://nix-community.github.io/home-manager/
- **Omarchy-nix**: https://github.com/henrysipp/omarchy-nix

## ✨ You're Ready!

Your NixOS system is configured and ready to deploy. The new setup provides:

- ✨ Modern tiling window manager (Hyprland)
- 🎨 Beautiful omarchy aesthetics
- 📦 All your original packages preserved
- 🔧 Modular, maintainable configuration
- 🔄 Reproducible builds with flakes
- 🏠 User configuration with home-manager

**When ready, run**:
```bash
sudo nixos-rebuild switch --flake .#helios
sudo reboot
```

Good luck with your new Hyprland setup! 🚀