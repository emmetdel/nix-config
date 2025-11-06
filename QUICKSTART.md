# Quick Start: Minimal Omarchy NixOS

Get productive in 5 minutes with your new web-first NixOS setup!

## 🚀 First Boot

After rebuilding and rebooting:

1. Login screen → Select **Hyprland** session
2. Enter your password
3. You'll see Waybar at the top with Tokyo Night colors

## ⌨️ Essential Shortcuts (Learn These First!)

```
Super + Return    → Terminal
Super + D         → App launcher
Super + F         → Firefox
Super + W         → Web apps menu ← Most important!
Super + L         → Lock screen
Super + Q         → Close window
```

## 🌐 Using Web Apps (The Omarchy Way!)

### Launch Your First PWA

1. Press `Super + W`
2. Rofi menu appears with your web apps
3. Select **Gmail** (or any app)
4. Gmail opens in its own window - looks just like a native app!

### What Just Happened?

- Gmail launched as a dedicated Chromium app window
- It has its own isolated storage (stays logged in separately)
- Auto-moved to Workspace 1 (Communication)
- Has its own window class for Hyprland rules

### Launch More PWAs

Try them all:
- `Super + W` → **Calendar** (Workspace 1)
- `Super + W` → **Linear** (Workspace 4)
- `Super + W` → **Notion** (Workspace 4)
- `Super + W` → **ChatGPT** (Workspace 4)

GitHub opens in Firefox (not a PWA - better for dev work).

## 📋 Your First Tasks

### 1. Set Up Git
```bash
# Open terminal
Super + Return

# Configure git (if not already done)
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 2. Add a Wallpaper (Optional)
```bash
mkdir -p ~/.config
cp /path/to/your/wallpaper.jpg ~/.config/wallpaper.jpg
# Logout and back in to see it
```

### 3. Test PWAs
```bash
# Launch Gmail
Super + W, then select Gmail

# Switch to workspace 1 to see it
Super + 1

# Launch Linear
Super + W, then select Linear

# Switch to workspace 4
Super + 4
```

## 🎯 Daily Workflow Example

### Morning Routine
```
Super + 1                    # Go to Communication workspace
Super + W → Gmail            # Check email
Super + W → Calendar         # Check schedule
Super + 3                    # Go to Research workspace
Super + F                    # Open Firefox for reading
```

### Development Session
```
Super + 2                    # Go to Development workspace
Super + E                    # Open VSCode
Super + Return               # Open Terminal
# Code away!
```

### Planning Session
```
Super + 4                    # Go to Planning workspace
Super + W → Linear           # Check tasks
Super + W → Notion           # Take notes
Super + W → ChatGPT          # Get AI help
```

## 🔧 Common Tasks

### Take a Screenshot
```
Print              # Select area with mouse
Shift + Print      # Full screen
# Automatically copied to clipboard!
```

### Navigate Windows
```
Super + H/J/K/L     # Vim-style navigation
Super + Arrows      # Or use arrow keys
Super + 1-9         # Jump to workspace
Super + Tab         # Cycle windows
```

### Manage Windows
```
Super + Shift + F   # Toggle floating
Super + Shift + M   # Fullscreen
Super + Q           # Close window
Super + click-drag  # Move window
Super + right-click-drag # Resize window
```

## 📦 Add More Software

```bash
# Edit packages
vim ~/code/personal/nix-config/home/emmetdelaney/packages.nix

# Add your package to home.packages
# Then rebuild
rebuild
```

## 🌐 Add More Web Apps

Edit `~/code/personal/nix-config/home/emmetdelaney/web-apps.nix`:

```nix
webApps = {
  # ... existing apps ...
  
  yourapp = {
    name = "YourApp";
    url = "https://yourapp.com";
    usePWA = true;  # Dedicated window with isolated storage
    key = "Y";
  };
};
```

Then rebuild:
```bash
rebuild
```

Now `Super + W` shows your new app!

## 🎨 Understanding Your Desktop

### Waybar (Top Bar)
- **Left**: Workspace numbers & current window title
- **Center**: Clock
- **Right**: Volume, Network, Battery, System tray

### PWA Window Classes
Each PWA has its own window class:
- Gmail windows are class "Gmail"
- Calendar windows are class "Calendar"
- This allows Hyprland to apply special rules (auto-workspace, sizing)

### Workspace Organization
- **1**: Communication (email, calendar)
- **2**: Development (code, terminal)
- **3**: Research (browser tabs)
- **4**: Planning (project tools, AI, notes)
- **5-10**: Your choice!

## 🔍 Troubleshooting

### PWA Doesn't Launch?
```bash
# Test chromium manually
chromium --app=https://gmail.com

# Check if scripts are executable
ls -la ~/.local/share/applications/
```

### Window Not Auto-Organizing?
- Check window class: `Super + D` → Hyprland Info (if you added it)
- Or press `Super + Q` to close and relaunch

### Waybar Missing?
```bash
# Restart waybar
killall waybar
waybar &
```

### Want to Go Back?
```bash
# Checkout previous state
cd ~/code/personal/nix-config
git checkout pre-minimal-backup
rebuild
```

## 📝 Shell Aliases

Built-in convenience:
```bash
rebuild    # Rebuild NixOS config
update     # Update flake inputs
cleanup    # Remove old generations
gs         # Git status
ll         # List files with icons
```

## 🎓 Next Steps

### Learn More Keybindings
See full list: Check `hyprland.nix` or press `Super + D` → type "keyboard"

### Customize Your Workflow
1. Figure out which PWAs you use daily
2. Add them to `web-apps.nix`
3. Organize workspaces to match your workflow
4. Create custom keybindings for frequent actions

### Master Hyprland
- Learn window tiling: practice using `Super + H/J/K/L`
- Try special workspace (scratchpad): `Super + S`
- Experiment with window rules in `hyprland.nix`

## ⚡ Pro Tips

1. **PWAs vs Browser Tabs**: Use PWAs for apps you keep open all day (email, chat, notes). Use Firefox for research/reading.

2. **Workspace Persistence**: PWAs remember which workspace they're in. Open Gmail → it always goes to Workspace 1.

3. **Isolated Storage**: Each PWA has separate cookies/localstorage. You can be logged into different accounts!

4. **Desktop Entries**: Your PWAs appear in Rofi launcher (`Super + D`) like native apps.

5. **Fast Switching**: `Super + [number]` is faster than Alt+Tab for workspace-organized apps.

## 🎉 You're Ready!

You now have:
- ✅ Beautiful Tokyo Night desktop
- ✅ PWAs that feel native
- ✅ Keyboard-driven workflow
- ✅ Organized workspaces
- ✅ Minimal, fast system

**Start your web-first journey!** Open `Super + W` and get productive! 🚀

---

**Questions?** Check `README.md` for more details or the full configuration files.