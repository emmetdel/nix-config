# Migration Guide: Dotfiles Refactoring

This document outlines the comprehensive refactoring of the Nix dotfiles repository and provides guidance for migrating to the new structure.

## Overview of Changes

The repository has been completely restructured to follow best practices for Nix flakes, improve modularity, and enhance maintainability.

## New Directory Structure

```
.
├── .github/
│   └── workflows/
│       └── ci.yml                 # CI/CD pipeline
├── hosts/
│   ├── nixos/
│   │   ├── desktop/
│   │   │   └── apollo/            # Desktop systems
│   │   └── server/
│   │       └── theia/             # Server systems
│   └── darwin/
│       ├── macbook-pro/           # macOS systems
│       └── macbook-air/
├── modules/
│   ├── common/                    # Cross-platform modules
│   │   ├── users.nix
│   │   ├── development.nix
│   │   ├── security.nix
│   │   ├── networking.nix
│   │   └── default.nix
│   ├── nixos/                     # NixOS-specific modules
│   ├── darwin/                    # macOS-specific modules
│   └── home-manager/              # Home Manager modules
├── profiles/                      # Reusable configuration profiles
│   ├── desktop.nix
│   ├── server.nix
│   ├── development.nix
│   ├── minimal.nix
│   └── default.nix
├── lib/                          # Custom library functions
│   └── default.nix
├── secrets/                      # SOPS-encrypted secrets
│   ├── global/
│   ├── hosts/
│   ├── services/
│   └── README.md
├── .pre-commit-config.yaml       # Code quality hooks
├── .sops.yaml                    # SOPS configuration
├── .secrets.baseline             # Secrets detection baseline
├── flake.nix                     # Main flake configuration
├── shell.nix                     # Development shell
├── Justfile                      # Task runner
└── README.md                     # Main documentation
```

## Key Improvements

### 1. Modular Architecture

- **Common Modules**: Cross-platform modules that work on both NixOS and Darwin
- **Platform-Specific Modules**: Specialized modules for each platform
- **Profiles**: Pre-configured combinations of modules for different use cases

### 2. Better Organization

- **Host Categorization**: Hosts are organized by platform and purpose (desktop/server)
- **Separation of Concerns**: System configuration vs user configuration
- **Reusable Components**: Profiles and modules can be easily shared between hosts

### 3. Enhanced Security

- **SOPS Integration**: Proper secrets management with age encryption
- **Pre-commit Hooks**: Automated security scanning and code quality checks
- **Secrets Detection**: Prevents accidental commit of sensitive data

### 4. Development Workflow

- **CI/CD Pipeline**: Automated testing and deployment
- **Development Shell**: Comprehensive tooling for development
- **Task Runner**: Common tasks automated with Just
- **Code Quality**: Formatting, linting, and security checks

## Migration Steps

### 1. Update Your Age Keys

```bash
# Generate new age keys if you don't have them
age-keygen -o ~/.config/sops/age/keys.txt

# Update .sops.yaml with your public keys
# Replace the placeholder keys with your actual public keys
```

### 2. Update Host Configurations

Your existing host configurations have been moved and updated:

- `hosts/nixos/apollo/` → `hosts/nixos/desktop/apollo/`
- New configurations use profiles for better modularity

### 3. Update Flake Commands

The flake structure has been updated. New commands:

```bash
# Build NixOS configurations
nix build .#nixosConfigurations.apollo.config.system.build.toplevel
nix build .#nixosConfigurations.theia.config.system.build.toplevel

# Build Darwin configurations
nix build .#darwinConfigurations.macbook-pro.system
nix build .#darwinConfigurations.macbook-air.system

# Build Home Manager configurations
nix build .#homeConfigurations.apollo.activationPackage

# Deploy configurations
nix run .#deploy -- .#apollo
nix run .#deploy -- .#theia
```

### 4. Set Up Development Environment

```bash
# Enter development shell
nix develop

# Install pre-commit hooks
pre-commit install

# Run all checks
just check

# Format code
just fmt

# Build all configurations
just build-all
```

### 5. Configure Secrets

```bash
# Create your first secret file
sops secrets/global/example.yaml

# Add secrets to your configuration
# See secrets/README.md for detailed instructions
```

## Breaking Changes

### Configuration Structure

- **Module Imports**: Updated to use new module structure
- **Profile System**: Hosts now import profiles instead of individual modules
- **Common Modules**: New common module system for cross-platform compatibility

### File Locations

- **Host Configs**: Moved to categorized directories
- **Modules**: Reorganized by platform and purpose
- **Secrets**: New SOPS-based structure

### Flake Outputs

- **New Lib Functions**: Custom library functions for generating configurations
- **Profile System**: New profile-based configuration system
- **Updated Paths**: Host paths updated to reflect new structure

## Testing Your Migration

### 1. Check Flake Validity

```bash
nix flake check
```

### 2. Build Configurations

```bash
# Test build without applying
nix build .#nixosConfigurations.apollo.config.system.build.toplevel --dry-run
```

### 3. Run Pre-commit Checks

```bash
pre-commit run --all-files
```

### 4. Test Deployment (Dry Run)

```bash
# Test deployment without applying changes
nix run .#deploy -- .#apollo --dry-activate
```

## Rollback Plan

If you encounter issues, you can rollback by:

1. **Git Reset**: Use git to revert to the previous commit
2. **Backup Restore**: Restore from your system backup
3. **Manual Rebuild**: Use your existing configuration files

## Common Issues and Solutions

### 1. Module Not Found Errors

**Problem**: `error: attribute 'moduleName' missing`

**Solution**: Update module imports to use new structure:
```nix
# Old
inputs.self.nixosModules.moduleName

# New
inputs.self.commonModules.moduleName
# or
inputs.self.profiles.profileName
```

### 2. SOPS Decryption Errors

**Problem**: `Failed to decrypt file`

**Solution**: 
1. Ensure your age key is in the correct location
2. Verify your public key is in `.sops.yaml`
3. Re-encrypt secrets with updated keys

### 3. Build Failures

**Problem**: Configuration fails to build

**Solution**:
1. Check flake validity: `nix flake check`
2. Review error messages for missing dependencies
3. Ensure all imports are correct

## Getting Help

1. **Documentation**: Check the README.md files in each directory
2. **Examples**: Look at the example configurations in profiles/
3. **Issues**: Create an issue in the repository for specific problems
4. **Community**: Ask questions in the Nix community forums

## Next Steps

After migration:

1. **Customize Profiles**: Adapt the profiles to your specific needs
2. **Add Secrets**: Set up your secrets management
3. **Configure CI/CD**: Set up GitHub Actions for automated deployment
4. **Extend Modules**: Add new modules as needed
5. **Document Changes**: Keep your documentation up to date

## Validation Checklist

- [ ] Flake checks pass: `nix flake check`
- [ ] Configurations build successfully
- [ ] Pre-commit hooks are installed and passing
- [ ] Secrets are properly encrypted and accessible
- [ ] Development shell works correctly
- [ ] Deployment works (dry-run tested)
- [ ] All hosts are accessible and functional
- [ ] Documentation is updated

## Benefits of New Structure

1. **Maintainability**: Easier to maintain and extend
2. **Reusability**: Modules and profiles can be shared
3. **Security**: Better secrets management and security practices
4. **Quality**: Automated code quality and testing
5. **Documentation**: Comprehensive documentation and examples
6. **Scalability**: Easy to add new hosts and configurations

This refactoring provides a solid foundation for managing your Nix configurations at scale while following best practices and maintaining security.