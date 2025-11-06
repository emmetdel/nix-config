# Quick Start Guide

Get up and running with your Omarchy-inspired NixOS configuration in minutes!

## 🚀 First-Time Setup

### 1. Initial System Build

After cloning and customizing the configuration:

```bash
cd ~/personal-code/nix-config
sudo nixos-rebuild switch --flake .#helios
```

### 2. First Login

After the build completes:
1. Log out or reboot
2. At the login screen, select "Hyprland" as your session
3. Log in with your user credentials

### 3. Essential First Steps

Once logged into Hyprland:

```bash
# Setup GitHub authentication
gh auth login

# Set your wallpaper (optional)
mkdir -p ~/.config
cp /path/to/your/wallpaper.jpg ~/.config/wallpaper.jpg

# Test the clipboard manager
echo "test" | wl-copy
# Press Super + Shift + V to see clipboard history

# Lock and unlock screen to test
# Press Super + L
```

## 🎯 Daily Workflow

### Opening Applications

```bash
# Quick launcher
Super + D         # Opens Rofi - type to search apps

# Common apps
Super + Return    # Terminal
Super + E         # File manager
Super + Shift + B # Browser
Super + Shift + C # Code editor
Super + W         # Web apps menu
```

### Window Management

```bash
# Move between windows
Super + H/J/K/L   # Vim-style navigation
Super + Arrows    # Arrow key navigation

# Organize windows
Super + F         # Fullscreen
Super + V         # Toggle floating
Super + Q         # Close window

# Workspaces
Super + 1-9       # Switch workspace
Super + Shift + 1-9  # Move window to workspace
```

### Screenshots

```bash
Print             # Select area to screenshot
Shift + Print     # Full screen screenshot
```

## 💼 Development Setup

### Git Configuration

Your Git is already configured with:
- Name and email from `dev-tools.nix`
- Delta for beautiful diffs
- Useful aliases: `git lg`, `git visual`

Test it:
```bash
git status        # or: gs
git log --oneline # or: git lg
```

### Terminal Multiplexing

Tmux is configured and ready:
```bash
tmux              # Start new session
# Prefix key is Ctrl+A (not Ctrl+B)
Ctrl+A |          # Split vertical
Ctrl+A -          # Split horizontal
Ctrl+A h/j/k/l    # Navigate panes
```

### Container Development

Docker and Podman are ready:
```bash
docker --version
podman --version

# Test with hello-world
docker run hello-world
```

## 🎨 Customizing Your Setup

### Change Theme

Edit `home/emmetdelaney/themes.nix`:
```nix
# Change this line:
activeTheme = themes.catppuccin-mocha;
# Options: tokyo-night, catppuccin-mocha, nord, gruvbox
```

Then rebuild:
```bash
rebuild  # Alias for nixos-rebuild
```

### Add Packages

Edit `home/emmetdelaney/packages.nix` and add to `home.packages`:
```nix
home.packages = with pkgs; [
  # Add your packages here
  discord
  spotify
  vlc
];
```

Rebuild to install:
```bash
rebuild
```

### Customize Keybindings

Edit `home/emmetdelaney/hyprland.nix`:
```nix
bind = [
  # Add your custom keybindings
  "$mod SHIFT, D, exec, discord"
  # ... more bindings
];
```

## 📋 Essential Commands

### System Management
```bash
rebuild           # Rebuild and switch config
update            # Update flake inputs
cleanup           # Remove old generations
```

### File Operations
```bash
ll                # List files with icons
tree              # Show directory tree
z <partial-name>  # Jump to directory
yazi              # Terminal file manager
```

### Git Operations
```bash
g                 # Git shorthand
gs                # Git status
ga .              # Git add all
gc -m "msg"       # Git commit
gp                # Git push
lazygit           # Beautiful git TUI
```

### System Information
```bash
fastfetch         # System info with colors
btop              # System monitor
htop              # Process viewer
```

## 🔧 Troubleshooting

### Screen Won't Lock?
```bash
# Manually test swaylock
swaylock

# Check swayidle is running
ps aux | grep swayidle
```

### Clipboard History Not Working?
```bash
# Check cliphist service
systemctl --user status cliphist

# Restart if needed
systemctl --user restart cliphist
```

### Theme Not Applied?
```bash
# Ensure you rebuilt after changing theme
rebuild

# Log out and back in
```

### Waybar Not Showing?
```bash
# Restart waybar
killall waybar
waybar &
```

## 🎓 Learning Resources

### Hyprland
- Use `Super + ?` for help (if configured)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- Check `KEYBINDINGS.md` for complete reference

### Nix/NixOS
- `man configuration.nix` - System config options
- `man home-configuration.nix` - Home Manager options
- [NixOS Search](https://search.nixos.org/) - Find packages

### Shell Tips
```bash
# History search
Ctrl + R          # Search command history

# Directory navigation
z doc             # Jump to Documents (or any frecent dir)
..                # Go up one directory
...               # Go up two directories

# File search
fd <pattern>      # Find files
rg <pattern>      # Search in files
```

## 🌟 Pro Tips

1. **Use Workspaces**: Organize by project/context
   - Workspace 1: Communication (Slack, Email)
   - Workspace 2: Code (Editor, Terminal)
   - Workspace 3: Browser (Research)
   - Workspace 4: Music/Media

2. **Master the Scratchpad**: 
   - `Super + Shift + S` - Send window to scratchpad
   - `Super + S` - Toggle scratchpad visibility
   - Perfect for calculator, notes, music player

3. **Web Apps Launcher**:
   - `Super + W` opens your custom web apps menu
   - Edit `home/emmetdelaney/utilities.nix` to add more

4. **Tmux for Projects**:
   ```bash
   # Name your sessions by project
   tmux new -s myproject
   tmux attach -t myproject
   ```

5. **Direnv for Project Environments**:
   ```bash
   # In project directory, create .envrc
   echo "use nix" > .envrc
   direnv allow
   ```

## 🎉 Next Steps

- [ ] Set a wallpaper you love
- [ ] Customize your web apps in `utilities.nix`
- [ ] Set up GitHub CLI (`gh auth login`)
- [ ] Explore the themes (Tokyo Night, Catppuccin, Nord, Gruvbox)
- [ ] Create a tmux session for your main project
- [ ] Learn the most important keybindings
- [ ] Join the [NixOS Discourse](https://discourse.nixos.org/)

---

**Enjoy your beautiful, productive NixOS setup!** 🚀

For detailed keybindings, see `KEYBINDINGS.md`  
For customization, see `CUSTOMIZATION.md`  
For architecture details, see `ARCHITECTURE.md`

