# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  gc = import ./gc.nix;
  desktop = import ./desktop.nix;
  development = import ./development.nix;
  amd-optimization = import ./amd-optimization.nix;
  basic-system = import ./basic-system.nix;
  shared = import ./shared.nix;
  users = import ./users.nix;
}
