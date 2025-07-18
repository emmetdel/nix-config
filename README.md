# Emmet's Nix Configuration

A modular and well-organized Nix configuration for managing NixOS systems, macOS with nix-darwin, and user environments with Home Manager.

## 🏗️ Structure

```
.
├── .github/
│   └── workflows/           # CI/CD pipelines
├── hosts/                   # Host configurations
│   ├── nixos/
│   │   ├── desktop/        # Desktop systems
│   │   └── server/         # Server systems
│   └── darwin/             # macOS systems
├── modules/
│   ├── common/             # Cross-platform modules
│   ├── nixos/              # NixOS-specific modules
│   ├── darwin/             # macOS-specific modules
│   └── home-manager/       # Home Manager modules
├── profiles/               # Reusable configuration profiles
├── lib/                    # Custom library functions
├── secrets/                # SOPS-encrypted secrets
├── overlays/               # Package overlays
├── pkgs/                   # Custom packages
├── .pre-commit-config.yaml # Code quality hooks
├── .sops.yaml              # SOPS configuration
├── Justfile                # Task runner
└── shell.nix               # Development shell
```

## 🚀 Quick Start

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- [Git](https://git-scm.com/) for cloning the repository

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/emmetdelaney/dotfiles.git ~/.config/nixos
   cd ~/.config/nixos
   ```

2. **For NixOS systems:**
   ```bash
   # Build and switch to the configuration
   sudo nixos-rebuild switch --flake .#hostname
   ```

3. **For Home Manager (standalone):**
   ```bash
   # Build and switch to the home configuration
   home-manager switch --flake .#hostname
   ```

4. **For macOS with nix-darwin:**
   ```bash
   # Build and switch to the darwin configuration
   darwin-rebuild switch --flake .#hostname
   ```

## 🖥️ Hosts

### NixOS Desktop Systems

- **apollo** - Desktop workstation (Beelink SER8)
  - AMD Ryzen 7 8845HS
  - Hyprland desktop environment
  - Development workstation setup
  - Location: `hosts/nixos/desktop/apollo/`

### NixOS Server Systems

- **theia** - Server system
  - Headless configuration
  - Server profile with minimal GUI
  - Location: `hosts/nixos/server/theia/`

### macOS Systems

- **macbook-pro** - MacBook Pro configuration
  - Development profile with comprehensive tooling
  - Location: `hosts/darwin/macbook-pro/`

- **macbook-air** - MacBook Air configuration
  - Minimal profile for better battery life
  - Location: `hosts/darwin/macbook-air/`

## 🧩 Architecture

### Profiles

Pre-configured combinations of modules for different use cases:

- **Desktop** - Complete desktop workstation with GUI applications
- **Server** - Minimal server configuration for headless systems
- **Development** - Comprehensive development environment with all tools
- **Minimal** - Bare minimum configuration for resource-constrained systems

### Common Modules

Cross-platform modules that work on both NixOS and Darwin:

- **users** - User management and SSH configuration
- **development** - Development tools and programming languages
- **security** - Security configuration and tools
- **networking** - Network configuration and tools

### Platform-Specific Modules

#### NixOS Modules
- **basic-system** - Essential system configuration
- **desktop** - Desktop environment with Hyprland
- **amd-optimization** - AMD-specific optimizations
- **gc** - Garbage collection configuration

#### Darwin Modules
- **basic-system** - macOS system configuration
- **homebrew** - Homebrew package management

#### Home Manager Modules
- **hyprland** - Hyprland window manager configuration

## 🔧 Configuration

### Adding a New Host

1. **Create host directory:**
   ```bash
   mkdir -p hosts/nixos/new-hostname
   ```

2. **Create configuration file:**
   ```nix
   # hosts/nixos/new-hostname/default.nix
   { inputs, outputs, pkgs, user, ... }: {
     imports = [
       ./hardware-configuration.nix
       inputs.self.nixosModules.basic-system
       # Add other modules as needed
     ];

     basic-system = {
       enable = true;
       hostname = "new-hostname";
     };

     # Add host-specific configuration
   }
   ```

3. **Update flake.nix:**
   ```nix
   nixosConfigurations = lib.genNixosConfigs {
     hosts = {
       new-hostname = {
         system = "x86_64-linux";
         modules = [ /* additional modules */ ];
       };
     };
   };
   ```

### Customizing Modules

Each module is designed to be configurable. Check the module files in `modules/` for available options.

Example:
```nix
desktop = {
  enable = true;
  hyprland.enable = true;
  audio = {
    enable = true;
    lowLatency = false;
  };
  bluetooth.enable = true;
};
```

## 🔐 Secrets Management

This configuration uses [SOPS](https://github.com/Mic92/sops-nix) for secrets management.

### Adding Secrets

1. **Create/edit secrets file:**
   ```bash
   sops secrets/users/username-secrets.yaml
   ```

2. **Reference in configuration:**
   ```nix
   sops.secrets.user-password = {
     sopsFile = ../secrets/users/username-secrets.yaml;
   };
   ```

## 🚢 Deployment

This configuration supports deployment using [deploy-rs](https://github.com/serokell/deploy-rs).

### Deploy to Remote Host

```bash
# Deploy system configuration
deploy .#hostname

# Deploy specific profile
deploy .#hostname.system
```

### Local Development

```bash
# Check flake
nix flake check

# Build without switching
nixos-rebuild build --flake .#hostname

# Format code
nix fmt
```

## 🛠️ Development

### Available Commands

```bash
# Enter development shell
nix develop

# Format all Nix files
nix fmt

# Check flake for errors
nix flake check

# Update flake inputs
nix flake update
```

### Pre-commit Hooks

This repository includes pre-commit hooks for:
- Nix code formatting
- Syntax checking
- Secret scanning

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Darwin](https://github.com/LnL7/nix-darwin)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This configuration is available under the MIT License. See [LICENSE](LICENSE) for details.

---

**Note:** This is a personal configuration. While you're welcome to use it as inspiration, you may need to adapt it for your specific needs and hardware.