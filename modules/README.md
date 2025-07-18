# Modules

This directory contains reusable NixOS, Darwin, and Home Manager modules that can be shared across different host configurations.

## Structure

```
modules/
├── nixos/           # NixOS system modules
├── darwin/          # macOS system modules (nix-darwin)
└── home-manager/    # User environment modules
```

## NixOS Modules

### basic-system.nix

Essential system configuration including:
- Bootloader (systemd-boot)
- SSH server configuration
- Time and locale settings
- Basic system packages
- Nix configuration with flakes

**Usage:**
```nix
basic-system = {
  enable = true;
  hostname = "my-host";
  timezone = "Europe/Dublin";
  ssh = {
    enable = true;
    port = 22;
    authorizedKeys = [ "ssh-ed25519 ..." ];
  };
  packages = with pkgs; [ vim git ];
};
```

### desktop.nix

Desktop environment configuration with Hyprland:
- Hyprland wayland compositor
- Audio with PipeWire
- Bluetooth support
- Printing configuration
- Font management
- Essential desktop applications

**Usage:**
```nix
desktop = {
  enable = true;
  hyprland = {
    enable = true;
    enableXWayland = true;
  };
  audio = {
    enable = true;
    lowLatency = false;
  };
  bluetooth.enable = true;
  printing.enable = true;
  autoLogin = {
    enable = true;
    user = "username";
  };
};
```

### development.nix

Development environment setup:
- Programming languages (Python, Node.js, Rust, C++)
- Development tools
- IDE configurations

**Usage:**
```nix
development = {
  enable = true;
  languages = {
    python.enable = true;
    nodejs.enable = true;
    rust.enable = true;
  };
  tools.vscode.enable = true;
};
```

### users.nix

User management and SSH configuration:
- Admin user creation
- Deploy user for automation
- SSH key management
- Sudo configuration

**Usage:**
```nix
users = {
  enable = true;
  adminUser = "emmet";
  deployUser = "nixos-deploy";
  adminKeys = [ "ssh-ed25519 ..." ];
  deployKeys = [ "ssh-ed25519 ..." ];
  wheelNeedsPassword = false;
};
```

### amd-optimization.nix

AMD-specific optimizations:
- CPU microcode updates
- GPU driver configuration
- Performance tuning

**Usage:**
```nix
amd-optimization = {
  enable = true;
  cpu = {
    updateMicrocode = true;
    coreCount = 16;
  };
  gpu.enable = true;
};
```

### gc.nix

Garbage collection configuration:
- Automatic cleanup
- Storage optimization
- Retention policies

**Usage:**
```nix
gc.enable = true;
```

## Home Manager Modules

### hyprland.nix

Hyprland window manager configuration:
- Keybindings
- Window rules
- Startup applications
- Theme configuration

**Usage:**
```nix
hyprland = {
  enable = true;
  terminal = "kitty";
  menu = "wofi --show drun";
  fileManager = "dolphin";
  browser = "firefox";
  editor = "code";
};
```

## Creating New Modules

### Module Template

```nix
# modules/nixos/my-module.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my-module;
in {
  options.my-module = {
    enable = mkEnableOption "my custom module";
    
    option1 = mkOption {
      type = types.str;
      default = "default-value";
      description = "Description of option1";
      example = "example-value";
    };
    
    option2 = mkOption {
      type = types.bool;
      default = false;
      description = "Description of option2";
    };
  };

  config = mkIf cfg.enable {
    # Module implementation
    environment.systemPackages = with pkgs; [
      # packages
    ];
    
    services.my-service = {
      enable = true;
      # service configuration
    };
  };
}
```

### Best Practices

1. **Use descriptive option names** - Make it clear what each option does
2. **Provide good defaults** - Modules should work out of the box
3. **Add examples** - Help users understand how to use options
4. **Use mkIf conditionals** - Only apply configuration when module is enabled
5. **Group related options** - Use attribute sets for logical grouping
6. **Document everything** - Add descriptions to all options

### Adding to default.nix

After creating a new module, add it to the appropriate `default.nix`:

```nix
# modules/nixos/default.nix
{
  my-module = import ./my-module.nix;
  # ... other modules
}
```

## Testing Modules

Test your modules by:

1. **Building the configuration:**
   ```bash
   nixos-rebuild build --flake .#hostname
   ```

2. **Checking for errors:**
   ```bash
   nix flake check
   ```

3. **Testing in a VM:**
   ```bash
   nixos-rebuild build-vm --flake .#hostname
   ```

## Module Dependencies

Some modules depend on others:
- `desktop` requires `basic-system` for proper operation
- `development` works best with `desktop` for GUI applications
- `users` is typically required by most other modules

Ensure dependencies are imported in your host configuration.