# AGENTS.md

## Build/Lint/Test Commands

```bash
# Build system configuration
sudo nixos-rebuild switch --flake .#helios

# Update flake inputs
nix flake update

# Check flake syntax
nix flake check

# Evaluate flake without building
nix flake show

# Clean old generations
sudo nix-collect-garbage -d
```

Note: This NixOS configuration doesn't have traditional tests. Validation is done through successful builds.

## Secrets Management

This configuration uses `sops-nix` for managing secrets (SSH keys, API tokens, passwords).

```bash
# Edit encrypted secrets
cd secrets && sops secrets.yaml

# Verify secrets are encrypted
cat secrets/secrets.yaml

# Check sops configuration
cat .sops.yaml

# Test secret decryption (requires proper age key)
sops -d secrets/secrets.yaml
```

**Important:** Never commit unencrypted secrets. See `secrets/README.md` for full setup guide.

## Development Setup (macOS)

### Install Required Extensions

In VSCode/Cursor, install these extensions:
- **Nix IDE** (`jnoortheen.nix-ide`) - Nix language support with LSP
- **SOPS** (`signageos.signageos-vscode-sops`) - Edit encrypted secrets
- **EditorConfig** (`editorconfig.editorconfig`) - Consistent formatting

### Enable Nix Flakes and Commands (if not already done)

```bash
# Add to ~/.config/nix/nix.conf (create if it doesn't exist)
mkdir -p ~/.config/nix
cat >> ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
EOF
```

### Enter Development Environment

```bash
cd /Users/emmetdelaney/personal-code/nix-config
nix develop  # Provides alejandra, nixd, statix, deadnix, sops, age
```

Or for automatic environment activation, install direnv:

```bash
# Install direnv
nix profile install nixpkgs#direnv

# Add to ~/.zshrc
eval "$(direnv hook zsh)"

# Then in your config directory
echo "use flake" > .envrc
direnv allow
```

### Format and Check Commands

```bash
# Format all Nix files
alejandra .

# Check formatting (no changes)
alejandra -c .

# Run all checks (format, lint, validate)
./scripts/check.sh

# Format only
./scripts/fmt.sh
```

## Code Style Guidelines

### Nix Formatting
- Use 2-space indentation
- No trailing whitespace
- Place opening braces on same line
- One attribute per line for readability
- Use `let ... in` for local variables

### Imports
- Group imports logically (system modules, desktop modules, home modules)
- Use relative paths for local imports
- Keep imports in alphabetical order when possible

### Naming Conventions
- Use camelCase for variable names
- Use kebab-case for file names
- Use descriptive names for modules and configurations

### Types
- Prefer `lib.mkOption` for module options
- Use `lib.mkIf` for conditional configurations
- Use `lib.mkDefault` for default values

### Error Handling
- Use `assert` for preconditions
- Use `lib.warn` for deprecations
- Handle platform-specific configurations with `lib.mkIf pkgs.stdenv.isLinux`

### Special Considerations
- This configuration targets both Linux (NixOS) and potentially macOS
- Use `pkgs.stdenv.isLinux` or `pkgs.stdenv.isDarwin` for platform-specific code
- Keep configurations minimal and focused
- Follow the web-first philosophy with PWA integrations
