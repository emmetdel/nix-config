# Dotfiles

A modular NixOS and nix-darwin configuration with space-themed naming.

## Overview

This repository contains a modular Nix configuration for managing both NixOS and macOS (via nix-darwin) systems. It uses the Nix Flakes feature for reproducible builds and easy deployment.

The configuration is organized into modules that can be composed to create different system configurations. Each module is designed to be configurable and reusable.

## Repository Structure

```
.
├── flake.nix                # Main entry point for the flake
├── home/                    # Home Manager configurations
│   ├── common/              # Shared home-manager configurations
│   ├── darwin/              # macOS-specific home-manager configurations
│   └── nixos/               # NixOS-specific home-manager configurations
├── hosts/                   # Host-specific configurations
│   ├── darwin/              # macOS host configurations
│   │   ├── meteor/          # Configuration for 'meteor' macOS machine
│   │   └── quasar/          # Configuration for 'quasar' macOS machine
│   └── nixos/               # NixOS host configurations
│       ├── comet/           # Configuration for 'comet' NixOS machine (laptop)
│       ├── nebula/          # Configuration for 'nebula' NixOS machine (desktop)
│       └── pulsar/          # Configuration for 'pulsar' NixOS machine (server)
└── modules/                 # Reusable modules
    ├── darwin/              # macOS-specific modules
    │   └── system/          # macOS system configuration
    ├── nixos/               # NixOS-specific modules
    │   ├── packages/        # Package management
    │   ├── security/        # Security settings
    │   ├── services/        # Service configuration
    │   └── system/          # System configuration
    └── packages.nix         # Centralized package definitions
```

## Features

- **Modular Design**: Each aspect of the configuration is separated into modules that can be composed.
- **Multi-Platform Support**: Works with both NixOS and macOS (via nix-darwin).
- **Home Manager Integration**: User-specific configurations are managed with Home Manager.
- **Configurable**: Most settings can be configured per-host without modifying the modules.
- **Space-Themed Naming**: Hosts are named after celestial objects.

## Hosts

### NixOS

- **nebula**: Desktop workstation
- **comet**: Laptop
- **pulsar**: Server

### macOS

- **quasar**: Primary macOS machine
- **meteor**: Secondary macOS machine

## Usage

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Install Nix with flakes support:
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

3. Enable flakes:
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

### Deploying to a NixOS System

```bash
sudo nixos-rebuild switch --flake .#nebula
```

Replace `nebula` with the name of your host.

### Deploying to a macOS System

```bash
darwin-rebuild switch --flake .#quasar
```

Replace `quasar` with the name of your host.

### Deploying Home Manager Configuration

```bash
home-manager switch --flake .#nebula
```

Replace `nebula` with the name of your host.

## Customization

### Adding a New Host

1. Create a new directory under `hosts/nixos/` or `hosts/darwin/` with the name of your host.
2. Create a `configuration.nix` file in that directory.
3. Add the host to the `nixosConfigurations` or `darwinConfigurations` in `flake.nix`.

### Modifying Module Options

Each module exposes options that can be configured in the host configuration. For example:

```nix
dotfiles.system = {
  timeZone = "America/New_York";
  defaultLocale = "en_US.UTF-8";
  enableDocker = true;
};
```

See the module files for available options.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
