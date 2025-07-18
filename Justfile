# Justfile for deploying NixOS configurations using nixos-anywhere

#Example usage.
#just deploy myhost 192.168.1.100
#just update myhost

# First-time deployment of a host
deploy target ip user="nixos":
    @echo "Deploying {{target}} configuration to {{user}}@{{ip}}..."
    nix-shell -p nixos-anywhere --run "nixos-anywhere --flake .#{{target}} nixos@{{ip}} --build-on remote --show-trace"

# Update existing deployment using deploy-rs
update target:
    @echo "Adding deployment keys to agent..."
    just add-deploy-keys
    @echo "Updating {{target}} configuration..."
    nix run github:serokell/deploy-rs -- .#{{target}}

# Nix utilities
garbage-collect:
    nix-collect-garbage --delete-older-than 14d

# Check the flake for errors
check:
    @echo "Checking flake for errors..."
    nix flake check

# Update all flake inputs
update-flake:
    @echo "Updating flake inputs..."
    nix flake update

# Add all common deployment keys to agent
add-deploy-keys:
    @echo "Adding all deployment SSH keys to agent..."
    ssh-add ~/.ssh/nixos-deploy
    @echo "SSH keys added successfully"
