# Justfile for dotfiles repository
# Run `just --list` to see available commands

# Default recipe
default:
    @just --list

# Format all Nix files using alejandra
fmt:
    @echo "🎨 Formatting Nix files..."
    nix fmt

# Check flake for errors and warnings
check:
    @echo "🔍 Checking flake..."
    nix flake check

# Update flake inputs
update:
    @echo "⬆️  Updating flake inputs..."
    nix flake update

# Build a specific host configuration without switching
build host:
    @echo "🔨 Building {{host}} configuration..."
    nixos-rebuild build --flake .#{{host}}

# Build and switch to a host configuration (requires sudo)
switch host:
    @echo "🚀 Switching to {{host}} configuration..."
    sudo nixos-rebuild switch --flake .#{{host}}

# Deploy to a remote host using deploy-rs
deploy host:
    @echo "🚢 Deploying to {{host}}..."
    deploy .#{{host}}

# Build home-manager configuration
home-build host:
    @echo "🏠 Building home configuration for {{host}}..."
    home-manager build --flake .#{{host}}

# Switch to home-manager configuration
home-switch host:
    @echo "🏠 Switching to home configuration for {{host}}..."
    home-manager switch --flake .#{{host}}

# Show flake outputs
show:
    @echo "📋 Flake outputs:"
    nix flake show

# Clean up old generations and garbage collect
clean:
    @echo "🧹 Cleaning up..."
    sudo nix-collect-garbage -d
    nix-collect-garbage -d

# Setup pre-commit hooks
setup-hooks:
    @echo "🪝 Setting up pre-commit hooks..."
    pre-commit install
    pre-commit install --hook-type commit-msg

# Run pre-commit hooks on all files
lint:
    @echo "🔍 Running pre-commit hooks..."
    pre-commit run --all-files

# Generate hardware configuration for current system
hardware-config:
    @echo "⚙️  Generating hardware configuration..."
    nixos-generate-config --show-hardware-config

# Show system information
info:
    @echo "💻 System Information:"
    @echo "Hostname: $(hostname)"
    @echo "Kernel: $(uname -r)"
    @echo "Architecture: $(uname -m)"
    @echo "Nix version: $(nix --version)"
    @echo "NixOS version: $(nixos-version 2>/dev/null || echo 'Not on NixOS')"

# Search for packages
search query:
    @echo "🔍 Searching for packages matching '{{query}}'..."
    nix search nixpkgs {{query}}

# Show package information
package-info pkg:
    @echo "📦 Package information for '{{pkg}}':"
    nix eval nixpkgs#{{pkg}}.meta --json | jq

# Test configuration in VM
test-vm host:
    @echo "🖥️  Testing {{host}} in VM..."
    nixos-rebuild build-vm --flake .#{{host}}

# Create a new host template
new-host type name:
    @echo "📝 Creating new {{type}} host: {{name}}"
    @mkdir -p hosts/{{type}}/{{name}}
    @cp profiles/{{type}}.nix hosts/{{type}}/{{name}}/default.nix
    @echo "Host template created at hosts/{{type}}/{{name}}/default.nix"

# Backup current configuration
backup:
    @echo "💾 Creating backup..."
    @tar -czf "backup-$(date +%Y%m%d-%H%M%S).tar.gz" --exclude='.git' --exclude='result*' .
    @echo "Backup created: backup-$(date +%Y%m%d-%H%M%S).tar.gz"
