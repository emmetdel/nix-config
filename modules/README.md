# NixOS Modules

This directory contains reusable NixOS modules that can be used across different hosts in your configuration.

## Available Modules

### NixOS Modules (`modules/nixos/`)

#### `basic-system.nix`
Provides basic system configuration including:
- Hostname and timezone settings
- Bootloader configuration
- SSH server configuration
- Basic system packages

**Usage:**
```nix
basic-system = {
  enable = true;
  hostname = "my-host";
  timezone = "Europe/Dublin";
  ssh = {
    enable = true;
    authorizedKeys = ["ssh-key-here"];
  };
  packages = with pkgs; [ htop ];
};
```

#### `desktop.nix`
Provides desktop environment configuration including:
- Hyprland setup
- Audio with PipeWire
- Bluetooth support
- Printing services
- Desktop packages and fonts

**Usage:**
```nix
desktop = {
  enable = true;
  hyprland.enable = true;
  audio.enable = true;
  bluetooth.enable = true;
  printing.enable = true;
};
```

#### `development.nix`
Provides development environment configuration including:
- Programming language tools (Node.js, Python, Rust, C++)
- Development tools (VS Code, Neovim, Git)
- Common development utilities

**Usage:**
```nix
development = {
  enable = true;
  languages = {
    nodejs.enable = true;
    python.enable = true;
    rust.enable = true;
    cpp.enable = true;
  };
  tools = {
    vscode.enable = true;
    neovim.enable = true;
    git.enable = true;
  };
};
```

#### `amd-optimization.nix`
Provides AMD-specific optimizations including:
- CPU microcode updates
- Kernel module optimizations
- GPU optimizations
- Power management settings

**Usage:**
```nix
amd-optimization = {
  enable = true;
  cpu = {
    updateMicrocode = true;
    coreCount = 32; # Adjust based on your CPU
  };
  gpu.enable = true;
};
```

### Home Manager Modules (`modules/home-manager/`)

#### `hyprland.nix`
Provides Hyprland configuration including:
- Hyprland configuration file
- Waybar configuration and styling
- Default keybindings and settings

**Usage:**
```nix
# In home-manager configuration
hyprland = {
  enable = true;
  terminal = "kitty";
  menu = "wofi --show drun";
};
```

## Example Configurations

### Development Workstation
```nix
{
  # Basic system
  basic-system = {
    enable = true;
    hostname = "dev-workstation";
    ssh.enable = true;
  };

  # Desktop environment
  desktop = {
    enable = true;
    hyprland.enable = true;
    audio.enable = true;
  };

  # Development tools
  development = {
    enable = true;
    languages = {
      nodejs.enable = true;
      python.enable = true;
      rust.enable = true;
    };
    tools = {
      vscode.enable = true;
      neovim.enable = true;
    };
  };

  # Hardware optimizations
  amd-optimization = {
    enable = true;
    cpu.coreCount = 32;
    gpu.enable = true;
  };
}
```

### Server
```nix
{
  # Basic system
  basic-system = {
    enable = true;
    hostname = "server";
    ssh.enable = true;
  };

  # Minimal development tools
  development = {
    enable = true;
    languages = {
      python.enable = true;
    };
    tools = {
      git.enable = true;
      neovim.enable = true;
    };
  };

  # CPU optimizations only
  amd-optimization = {
    enable = true;
    cpu.coreCount = 16;
    gpu.enable = false;
  };
}
```

## Adding New Modules

To add a new module:

1. Create a new `.nix` file in the appropriate directory
2. Follow the module pattern with `options` and `config` sections
3. Add the module to the `default.nix` file in the directory
4. For home-manager modules, also add to `flake.nix` if needed

### Module Pattern
```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my-module;
in {
  options.my-module = {
    enable = mkEnableOption "Enable my module";
    # Add other options here
  };

  config = mkIf cfg.enable {
    # Add configuration here
  };
}
```

## Benefits of Modular Approach

1. **Reusability**: Modules can be used across different hosts
2. **Maintainability**: Changes to common functionality only need to be made in one place
3. **Flexibility**: Each host can enable only the modules it needs
4. **Consistency**: Ensures consistent configuration across hosts
5. **Documentation**: Each module is self-documenting with clear options

## Tips

- Use `mkIf` to conditionally enable features based on module options
- Keep modules focused on a single responsibility
- Use descriptive option names and descriptions
- Consider creating modules for common patterns in your infrastructure
- Test modules individually before combining them 