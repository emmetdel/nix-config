# Common modules that work across NixOS and Darwin
{
  users = import ./users.nix;
  development = import ./development.nix;
  security = import ./security.nix;
  networking = import ./networking.nix;
}
