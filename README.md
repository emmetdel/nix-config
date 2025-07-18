# Dotfiles

These are my dotfiles for my NixOS and Darwin systems. They manage all my servers and workstations.

## Hosts

### Theia

Theia is my home router/firewall. It runs NixOS and is responsible for all my network traffic.

### Aurora

Aurora is my main server. It runs all my services such as Jellyfin, Frigate and Sonarr.


### Helios

Helios is my workstation.


### Personal MacBook Pro

My personal laptop. Runs Nix Darwin on MacOS.

### Work MacBook Pro

My work laptop. Runs Nix Darwin on MacOS.

# Testing NixOS Configurations with nixos-anywhere in a VM

This repository contains NixOS configurations for various systems, including a router/firewall (Theia).

## Testing with a VM before deployment

Before deploying to real hardware, you can test your configurations in a VM:

### Basic VM Testing

To test a configuration in a VM without full deployment:

```bash
just test-vm-theia
```

This will build a VM with your configuration and run it.

### Testing with nixos-anywhere

To test the full nixos-anywhere deployment process in a VM:

1. Start a test VM with a NixOS minimal ISO:

```bash
just test-anywhere-vm
```

2. Once the VM boots:
   - Log in as `root` (no password initially)
   - Start the SSH server: `sudo systemctl start sshd`
   - Set a root password: `passwd`

3. In a new terminal window, deploy to the VM:

```bash
just deploy-anywhere-vm
```

This will use nixos-anywhere to deploy your configuration to the VM, just like it would to real hardware.

## Deployment to Real Hardware

When you're ready to deploy to real hardware:

```bash
just deploy-theia 192.168.1.100  # Replace with your target IP
```

## Other Testing Commands

- Check if configuration builds: `just check-theia`
- Perform a dry run: `just dry-run-theia 192.168.1.100`

## Troubleshooting

If you encounter issues with the VM:
- Make sure QEMU is installed
- Try adding `-enable-kvm` to the QEMU command if your system supports it
- Adjust memory and CPU settings as needed



