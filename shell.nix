# Development shell for the dotfiles repository
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "dotfiles-dev-shell";

  buildInputs = with pkgs; [
    # Nix tools
    nixpkgs-fmt
    alejandra
    nil
    nix-tree
    nix-output-monitor

    # Development tools
    git
    gh
    just

    # Deployment tools
    deploy-rs

    # Secrets management
    sops
    age
    ssh-to-age

    # Documentation
    mdbook

    # Shell utilities
    fzf
    ripgrep
    fd
    bat
    eza

    # Pre-commit hooks
    pre-commit
  ];

  shellHook = ''
    echo "🚀 Welcome to the dotfiles development environment!"
    echo ""
    echo "Available commands:"
    echo "  just --list          # Show available recipes"
    echo "  nix fmt             # Format all Nix files"
    echo "  nix flake check     # Check flake for errors"
    echo "  deploy .#hostname   # Deploy to remote host"
    echo ""
    echo "Pre-commit hooks are available. Run 'just setup-hooks' to install."

    # Set up git hooks directory if it doesn't exist
    if [ ! -d .git/hooks ]; then
      mkdir -p .git/hooks
    fi
  '';

  # Environment variables
  NIX_CONFIG = "experimental-features = nix-command flakes";
}
