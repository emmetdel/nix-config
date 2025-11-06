# Build & Installation Guide

This guide walks you through building and deploying your Omarchy-inspired NixOS configuration for the first time.

## 🔧 Prerequisites

### Required
- NixOS installed on your system
- Root/sudo access
- Internet connection
- Git installed

### Recommended
- Backup of important data
- Time (first build can take 30-60 minutes)
- Basic familiarity with NixOS

## 📋 Pre-Build Checklist

Before building, you need to customize a few settings:

### 1. Hardware Configuration

Generate your hardware configuration:
```bash
sudo nixos-generate-config --show-hardware-config > ~/hardware-temp.nix
```

Copy relevant hardware details to `hosts/helios/hardware.nix`, or replace that file entirely.

### 2. User Information

Edit `modules/system/users.nix`:
```nix
users.users.YOUR_USERNAME = {  # Change 'emmetdelaney' to your username
  isNormalUser = true;
  description = "Your Name";
  shell = pkgs.zsh;
  # ...
};
```

### 3. Home Manager Paths

Edit `home/emmetdelaney/default.nix`:
```nix
home.username = "YOUR_USERNAME";      # Your username
home.homeDirectory = "/home/YOUR_USERNAME";  # Your home directory
```

Consider renaming the `home/emmetdelaney/` directory to `home/YOUR_USERNAME/`.

### 4. Git Configuration

Edit `home/YOUR_USERNAME/dev-tools.nix`:
```nix
programs.git = {
  userName = "Your Name";
  userEmail = "your.email@example.com";
  # ...
};
```

### 5. Host Configuration

If your hostname isn't "helios", either:
- Rename `hosts/helios/` to `hosts/YOUR_HOSTNAME/`
- Update `flake.nix` to reference the new hostname

```nix
nixosConfigurations = {
  YOUR_HOSTNAME = nixpkgs.lib.nixosSystem {  # Change 'helios'
    # ...
  };
};
```

### 6. Keyboard Layout (if not GB)

Edit `home/YOUR_USERNAME/hyprland.nix`:
```nix
input = {
  kb_layout = "us";  # Change from "gb" if needed
  # ...
};
```

## 🚀 Building the Configuration

### Step 1: Clone the Repository

```bash
# Create directory structure
mkdir -p ~/personal-code
cd ~/personal-code

# Clone (or copy your config)
git clone <your-repo-url> nix-config
cd nix-config
```

### Step 2: Initial Build

```bash
# First, test the build without switching
sudo nixos-rebuild test --flake .#YOUR_HOSTNAME

# If successful, build and switch
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
```

**Note**: Replace `YOUR_HOSTNAME` with your actual hostname (e.g., `helios`).

### Common Build Issues

**Issue**: "error: getting status of '/nix/store/...': No such file or directory"
```bash
# Solution: Run nix-collect-garbage and try again
sudo nix-collect-garbage -d
```

**Issue**: "error: builder for '...' failed"
```bash
# Solution: Check if you have enough disk space
df -h

# Clean up if needed
sudo nix-store --gc
```

**Issue**: Package conflicts or evaluation errors
```bash
# Solution: Update flake inputs
nix flake update

# Then rebuild
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
```

## 🔄 First Boot

### Step 1: Reboot
```bash
sudo reboot
```

### Step 2: Login Screen
1. At the display manager, select "Hyprland" as your session
2. Enter your password and log in

### Step 3: Verify Installation

You should see:
- Waybar at the top
- Beautiful Hyprland desktop
- Transparent terminal (press `Super + Return`)

Test basic functionality:
```bash
# Test shell
echo $SHELL  # Should show /run/current-system/sw/bin/zsh

# Test tools
fastfetch    # System info
ll           # List files with icons
z            # Zoxide should be available

# Test keybindings
# Super + D should open Rofi
# Super + L should lock screen
```

## ⚙️ Post-Install Configuration

### 1. Set Up GitHub CLI
```bash
gh auth login
# Follow the prompts to authenticate
```

### 2. Set Wallpaper (Optional)
```bash
mkdir -p ~/.config
cp /path/to/your/wallpaper.jpg ~/.config/wallpaper.jpg

# Reload Hyprland (Super + Shift + R or logout/login)
```

### 3. Configure Bitwarden
```bash
# Launch Bitwarden
bitwarden &

# Or use CLI
bw login
```

### 4. Test Docker/Podman
```bash
# Test Docker
docker run hello-world

# Test Podman
podman run hello-world
```

### 5. Initialize Development Environment
```bash
# Create project directory
mkdir -p ~/projects

# Test direnv
cd ~/projects
echo "use nix" > .envrc
direnv allow
```

## 🎨 Customization After Install

### Change Theme

Edit `home/YOUR_USERNAME/themes.nix`:
```nix
activeTheme = themes.catppuccin-mocha;  # or nord, gruvbox
```

Rebuild:
```bash
sudo nixos-rebuild switch --flake ~/personal-code/nix-config#YOUR_HOSTNAME
```

### Add Packages

Edit `home/YOUR_USERNAME/packages.nix`:
```nix
home.packages = with pkgs; [
  # Add your packages
  discord
  spotify
  # ...
];
```

Rebuild:
```bash
sudo nixos-rebuild switch --flake ~/personal-code/nix-config#YOUR_HOSTNAME
```

### Shell Alias for Rebuilding

The configuration includes a `rebuild` alias. After first build, you can use:
```bash
rebuild  # Instead of the full nixos-rebuild command
```

## 🔍 Troubleshooting

### Waybar Not Showing?
```bash
# Manually start Waybar
waybar &

# Check for errors
journalctl --user -u waybar
```

### Notifications Not Working?
```bash
# Test notification
notify-send "Test" "If you see this, notifications work!"

# Check mako service
systemctl --user status mako
```

### Hyprland Crashes?
```bash
# Check logs
journalctl -b | grep -i hyprland

# Try switching to TTY (Ctrl + Alt + F2)
# Then switch back (Ctrl + Alt + F1)
```

### Screen Lock Not Working?
```bash
# Test manually
swaylock

# Check swayidle
ps aux | grep swayidle
systemctl --user status swayidle
```

## 📊 Build Time Expectations

| Phase | Approximate Time |
|-------|-----------------|
| Download packages | 10-20 minutes |
| Build packages | 5-15 minutes |
| Home Manager setup | 5-10 minutes |
| **Total** | **20-60 minutes** |

*Times vary based on internet speed and hardware.*

## 🔐 Security Considerations

### File Permissions
After build, check:
```bash
# Ensure your user owns home directory
ls -la /home/YOUR_USERNAME

# Fix if needed
sudo chown -R YOUR_USERNAME:users /home/YOUR_USERNAME
```

### Secrets Management
- Don't commit passwords or API keys to git
- Use Bitwarden or 1Password for secrets
- Consider using `agenix` or `sops-nix` for Nix secrets

## 📚 Next Steps

After successful build:

1. ✅ Read `QUICKSTART.md` for daily workflow
2. ✅ Review `KEYBINDINGS.md` to learn shortcuts
3. ✅ Explore `CUSTOMIZATION.md` for personalization
4. ✅ Check `IMPLEMENTATION_SUMMARY.md` for feature overview

## 🆘 Getting Help

### Resources
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [Hyprland Discord](https://discord.gg/hyprland)
- [r/NixOS on Reddit](https://reddit.com/r/NixOS)

### Debug Commands
```bash
# Check configuration for errors
sudo nixos-rebuild dry-build --flake .#YOUR_HOSTNAME

# Show what would change
sudo nixos-rebuild build --flake .#YOUR_HOSTNAME
nix store diff-closures /run/current-system ./result

# Verbose rebuild
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME --show-trace
```

## ✨ Success!

If you've made it here and everything is working, congratulations! You now have a beautiful, productive NixOS setup inspired by Omarchy.

Enjoy your new development environment! 🚀

---

**Need help?** Open an issue or check the documentation files.

**Working great?** Consider starring the repo and sharing your customizations!

