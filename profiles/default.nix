# Profiles Default Export
# Provides easy access to all configuration profiles
{
  inputs,
  outputs,
  ...
}: {
  # Desktop workstation profile
  # Complete desktop environment with GUI applications
  desktop = import ./desktop.nix;

  # Server profile
  # Headless server configuration with minimal GUI
  server = import ./server.nix;

  # Development profile
  # Comprehensive development environment with all tools
  development = import ./development.nix;

  # Minimal profile
  # Bare minimum configuration for resource-constrained systems
  minimal = import ./minimal.nix;
}
