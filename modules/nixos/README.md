# NixOS Modules

This directory contains reusable NixOS modules that can be shared across all your NixOS machines.

## Available Modules

- `basic-system.nix` - Basic system configuration (hostname, timezone, SSH, packages)
- `desktop.nix` - Desktop environment configuration (Hyprland, audio, bluetooth, printing)
- `development.nix` - Development environment (Node.js, Python, Rust, C++, tools)
- `amd-optimization.nix` - AMD CPU/GPU optimizations
- `gc.nix` - Garbage collection configuration
- `users.nix` - User management
- `shared.nix` - **Shared configuration that imports all modules**

## How to Use

### Option 1: Import Individual Modules

In your host's `configuration.nix`, import specific modules:

```nix
{
  imports = [
    inputs.self.nixosModules.basic-system
    inputs.self.nixosModules.desktop
    inputs.self.nixosModules.development
    # ... other modules as needed
  ];
}
```

### Option 2: Import All Modules (Recommended)

Use the shared module to import all available modules:

```nix
{
  imports = [
    inputs.self.nixosModules.shared
  ];
}
```

This gives you access to all modules and their options, but you only need to enable the ones you want.

## Module Configuration

### Basic System

```nix
basic-system = {
  enable = true;
  hostname = "my-host";
  timezone = "Europe/Dublin";
  ssh = {
    enable = true;
    authorizedKeys = ["ssh-ed25519 ..."];
  };
  packages = with pkgs; [
    firefox
    kitty
    # ... other packages
  ];
};
```

### Desktop Environment

```nix
desktop = {
  enable = true;
  hyprland.enable = true;
  audio.enable = true;
  bluetooth.enable = true;
  printing.enable = true;
};
```

### Development Environment

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

### AMD Optimizations

```nix
amd-optimization = {
  enable = true;
  cpu = {
    updateMicrocode = true;
    coreCount = 8; # Adjust based on your CPU
  };
  gpu.enable = true;
};
```

## Adding New Modules

1. Create a new `.nix` file in this directory
2. Add it to `default.nix` exports
3. Import it in `shared.nix` if you want it available to all hosts

Example new module:

```nix
# modules/nixos/my-module.nix
{ config, lib, pkgs, ... }: {
  options.my-module = {
    enable = lib.mkEnableOption "Enable my module";
    # ... other options
  };

  config = lib.mkIf config.my-module.enable {
    # ... configuration
  };
};
```

Then add to `default.nix`:

```nix
{
  # ... existing modules
  my-module = import ./my-module.nix;
}
```

And import in `shared.nix`:

```nix
imports = [
  # ... existing imports
  ./my-module.nix
];
```

## Benefits

- **DRY Principle**: Write once, use everywhere
- **Consistency**: All hosts get the same base configuration
- **Flexibility**: Enable only what you need per host
- **Maintainability**: Update modules in one place
- **Reusability**: Easy to add new hosts with minimal configuration 