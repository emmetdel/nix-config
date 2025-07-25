{
  description = "Emmet's Nix Configurations";

  inputs = {
    # Use the latest stable NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Hardware optimization
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home Manager for user-specific configurations
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake utils for multi-system support
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    flake-utils,
    ...
  } @ inputs: {
    nixosConfigurations = {
      nebula = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/nebula
        ];
      };
    };
  };
}
