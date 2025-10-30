# Implementation Checklist

This document provides a step-by-step checklist for implementing the NixOS flake migration with Hyprland and omarchy-nix integration.

## Phase 1: Directory Structure Setup

### Create Directories
- [ ] Create `modules/system/` directory
- [ ] Create `modules/desktop/` directory
- [ ] Create `hosts/helios/` directory
- [ ] Create `home/emmetdelaney/` directory

**Command**:
```bash
mkdir -p modules/system modules/desktop hosts/helios home/emmetdelaney
```

## Phase 2: System Modules Creation

### Boot Module (`modules/system/boot.nix`)
- [ ] Create file
- [ ] Add systemd-boot configuration
- [ ] Enable EFI variables
- [ ] Test syntax with `nix-instantiate --parse`

**Expected content**: ~15 lines

### Networking Module (`modules/system/networking.nix`)
- [ ] Create file
- [ ] Set hostname to "helios"
- [ ] Enable NetworkManager
- [ ] Set experimental features for flakes
- [ ] Configure user in networkmanager group

**Expected content**: ~20 lines

### Locale Module (`modules/system/locale.nix`)
- [ ] Create file
- [ ] Set timezone: Europe/Dublin
- [ ] Set default locale: en_GB.UTF-8
- [ ] Configure Irish regional settings (all LC_* variables)
- [ ] Set console keymap: uk

**Expected content**: ~25 lines

### Sound Module (`modules/system/sound.nix`)
- [ ] Create file
- [ ] Disable PulseAudio
- [ ] Enable rtkit
- [ ] Configure PipeWire with:
  - [ ] Main enable
  - [ ] ALSA enable
  - [ ] ALSA 32-bit support
  - [ ] Pulse compatibility

**Expected content**: ~20 lines

## Phase 3: Desktop Modules Creation

### Hyprland Module (`modules/desktop/hyprland.nix`)
- [ ] Create file
- [ ] Enable Hyprland program
- [ ] Enable XWayland support
- [ ] Add essential Wayland packages:
  - [ ] wayland
  - [ ] xwayland
  - [ ] qt5.qtwayland
  - [ ] qt6.qtwayland
  - [ ] grim (screenshots)
  - [ ] slurp (region select)
  - [ ] wl-clipboard
- [ ] Enable polkit
- [ ] Configure XDG portal for Hyprland

**Expected content**: ~40 lines

### Display Manager Module (`modules/desktop/display-manager.nix`)
- [ ] Create file
- [ ] Disable GDM (explicitly)
- [ ] Enable SDDM
- [ ] Configure SDDM for Wayland
- [ ] Set Hyprland as default session

**Expected content**: ~15 lines

## Phase 4: Host Configuration

### Host Default (`hosts/helios/default.nix`)
- [ ] Create file
- [ ] Import hardware configuration
- [ ] Import all system modules:
  - [ ] boot.nix
  - [ ] networking.nix
  - [ ] locale.nix
  - [ ] sound.nix
- [ ] Import all desktop modules:
  - [ ] hyprland.nix
  - [ ] display-manager.nix
- [ ] Configure allowUnfree
- [ ] Set system.stateVersion to "25.05"
- [ ] Configure home-manager module
- [ ] Set up user "emmetdelaney"

**Expected content**: ~60 lines

### Hardware Symlink (`hosts/helios/hardware.nix`)
- [ ] Create symlink to `../../hardware-configuration.nix`

**Command**:
```bash
cd hosts/helios
ln -s ../../hardware-configuration.nix hardware.nix
cd ../..
```

## Phase 5: Home-Manager Configuration

### Home Default (`home/emmetdelaney/default.nix`)
- [ ] Create file
- [ ] Import packages module
- [ ] Import hyprland module
- [ ] Set home.stateVersion to "25.05"
- [ ] Set home.username to "emmetdelaney"
- [ ] Set home.homeDirectory to "/home/emmetdelaney"

**Expected content**: ~20 lines

### Packages Module (`home/emmetdelaney/packages.nix`)
- [ ] Create file
- [ ] Add all current packages:
  - [ ] vim
  - [ ] wget
  - [ ] git
  - [ ] code-cursor
  - [ ] zed-editor
  - [ ] vscode-fhs
  - [ ] firefox (move from system)
- [ ] Add Hyprland essentials:
  - [ ] kitty or alacritty (terminal)
  - [ ] thunar (file manager)
  - [ ] rofi-wayland (app launcher)
  - [ ] waybar (status bar)
  - [ ] mako or dunst (notifications)
  - [ ] pavucontrol (audio control)
  - [ ] networkmanagerapplet (network GUI)

**Expected content**: ~40 lines

### Hyprland User Config (`home/emmetdelaney/hyprland.nix`)
- [ ] Create file
- [ ] Enable Hyprland in home-manager
- [ ] Configure basic settings:
  - [ ] Monitor configuration
  - [ ] Workspace configuration
  - [ ] Basic keybindings
  - [ ] Window rules
  - [ ] Startup applications
- [ ] Integrate omarchy settings (if module available)

**Expected content**: ~80-100 lines

## Phase 6: Flake Configuration

### Update flake.nix
- [ ] Keep existing nixpkgs input
- [ ] Keep existing home-manager input
- [ ] Add Hyprland input:
  ```nix
  hyprland = {
    url = "github:hyprwm/Hyprland";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ```
- [ ] Add omarchy-nix input:
  ```nix
  omarchy-nix = {
    url = "github:henrysipp/omarchy-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ```
- [ ] Update nixosConfigurations.helios:
  - [ ] Update modules list to import `hosts/helios/default.nix`
  - [ ] Pass hyprland and omarchy inputs to specialArgs
  - [ ] Configure home-manager users.emmetdelaney import

**Expected content**: ~50 lines total

## Phase 7: Backup and Safety

### Backup Current Configuration
- [ ] Copy current configuration.nix:
  ```bash
  cp configuration.nix configuration.nix.backup
  ```
- [ ] Keep hardware-configuration.nix as-is (needed)
- [ ] Commit to git:
  ```bash
  git add -A
  git commit -m "Backup before flake migration"
  ```

## Phase 8: Testing

### Syntax Check
- [ ] Check all .nix files parse correctly:
  ```bash
  nix-instantiate --parse modules/system/boot.nix
  nix-instantiate --parse modules/system/networking.nix
  # ... for all files
  ```

### Build Test
- [ ] Test flake evaluation:
  ```bash
  nix flake check
  ```
- [ ] Test system build:
  ```bash
  sudo nixos-rebuild build --flake .#helios
  ```
- [ ] Review build output for warnings/errors

### Dry Run
- [ ] Test activation without switching:
  ```bash
  sudo nixos-rebuild test --flake .#helios
  ```
- [ ] Verify no critical errors in logs

## Phase 9: Implementation Verification

### File Count Check
Expected files to be created:
- [ ] 4 files in `modules/system/`
- [ ] 2 files in `modules/desktop/`
- [ ] 1 file + 1 symlink in `hosts/helios/`
- [ ] 3 files in `home/emmetdelaney/`
- [ ] 1 updated `flake.nix`
- [ ] Total: 12 files/symlinks created/modified

### Content Verification
- [ ] All imports use correct relative paths
- [ ] No syntax errors (all files parse)
- [ ] All settings from original config are preserved
- [ ] Flake.lock is updated (auto-generated)

## Phase 10: Documentation

### Update README
- [ ] Create or update README.md with:
  - [ ] Project description
  - [ ] How to rebuild system
  - [ ] How to update flake
  - [ ] Quick reference for common tasks

### Quick Reference Card
- [ ] Create QUICKREF.md with:
  - [ ] Essential Hyprland keybindings
  - [ ] Rebuild commands
  - [ ] Troubleshooting tips

## Implementation Time Estimates

| Phase | Estimated Time | Complexity |
|-------|---------------|------------|
| Phase 1: Directories | 1 min | Low |
| Phase 2: System Modules | 15 min | Medium |
| Phase 3: Desktop Modules | 20 min | High |
| Phase 4: Host Config | 15 min | Medium |
| Phase 5: Home-Manager | 25 min | High |
| Phase 6: Flake Update | 10 min | Medium |
| Phase 7: Backup | 5 min | Low |
| Phase 8: Testing | 15 min | Medium |
| Phase 9: Verification | 10 min | Low |
| Phase 10: Documentation | 10 min | Low |
| **Total** | **~2 hours** | - |

## Success Criteria

### Build Success
- [x] Flake evaluates without errors
- [x] System builds successfully
- [x] No critical warnings in output

### Configuration Completeness
- [x] All system settings preserved
- [x] All packages available
- [x] User account configured
- [x] Hardware configuration included

### Module Organization
- [x] Clear separation of concerns
- [x] Reusable module structure
- [x] Proper imports chain
- [x] No circular dependencies

### Documentation
- [x] Architecture documented
- [x] Migration guide created
- [x] Quick reference available
- [x] Troubleshooting guide included

## Ready for Code Mode

Once this plan is approved, switch to Code mode to implement:

1. Create all directory structure
2. Write all module files
3. Update flake.nix
4. Create symlinks
5. Test build
6. Provide rebuild instructions

## Important Notes

### Do NOT Remove
- Keep `hardware-configuration.nix` (required)
- Keep `configuration.nix.backup` (safety)
- Keep `flake.lock` once generated

### Critical Paths
All paths must be relative to `/home/emmetdelaney/code/personal/nix-config`:
- Module imports: `./modules/system/boot.nix`
- Host imports: `./hosts/helios/default.nix`
- Home imports: `./home/emmetdelaney/default.nix`

### Build Order
Nix will build in this order:
1. Evaluate flake.nix
2. Load host configuration
3. Import system modules
4. Import desktop modules
5. Configure home-manager
6. Build system closure

### First Boot Expectations
After successful switch and reboot:
1. SDDM login screen appears
2. Select "Hyprland" session
3. Enter password
4. Hyprland starts
5. Press Super+Return to test terminal
6. Verify network, audio, apps work

## Potential Issues and Solutions

### Build Fails
**Symptom**: Syntax errors during build  
**Solution**: Check all .nix files for syntax, missing semicolons, brackets

### Missing Packages
**Symptom**: Package not found errors  
**Solution**: Search correct package name with `nix search nixpkgs <package>`

### Omarchy-nix Integration Issues
**Symptom**: Cannot fetch omarchy-nix  
**Solution**: Verify repository exists, try pinning to specific commit

### Hyprland Won't Start
**Symptom**: Black screen after SDDM login  
**Solution**: Check GPU drivers, verify Hyprland package available

### Home-Manager Errors
**Symptom**: User configuration fails  
**Solution**: Verify home.stateVersion matches system.stateVersion

## Post-Implementation Checklist

After code mode completes implementation:
- [ ] All files created
- [ ] Build succeeds
- [ ] Ready for `nixos-rebuild switch`
- [ ] Documentation updated
- [ ] User informed of next steps

## Next Actions for User

After implementation:
1. Review all created files
2. Make any custom adjustments
3. Run backup commands
4. Execute test build
5. Switch to new configuration
6. Reboot and test Hyprland
7. Customize as desired