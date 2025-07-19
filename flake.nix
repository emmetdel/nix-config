{
  description = "Modular NixOS dotfiles with space-themed naming";

  # Define the inputs (dependencies) for this flake
  inputs = {
    # Use the unstable branch of nixpkgs for cutting-edge packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Also include a stable version for fallback or specific needs
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Home Manager for user-specific configurations
    home-manager = {
      url = "github:nix-community/home-manager";
      # Ensure it uses the same nixpkgs as the system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin for macOS system configurations
    darwin = {
      url = "github:LnL7/nix-darwin";
      # Use the same nixpkgs as the system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake-parts for better flake organization
    flake-parts.url = "github:hercules-ci/flake-parts";
    # sops-nix for secret management
    sops-nix.url = "github:Mic92/sops-nix";
  };

  # Define the outputs of this flake
  outputs =
    inputs@{ flake-parts, ... }:
    let
      # Helper function to generate NixOS configurations
      # This reduces repetition and standardizes configuration
      mkNixosConfiguration =
        {
          hostname,
          system ? "x86_64-linux",
        }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            (./hosts/nixos + "/${hostname}/configuration.nix")
            ./modules/nixos/system
          ];
        };

      # Helper function to generate Darwin configurations
      # Similar to mkNixosConfiguration but for macOS
      mkDarwinConfiguration =
        {
          hostname,
          system ? "x86_64-darwin",
        }:
        inputs.darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            (./hosts/darwin + "/${hostname}/configuration.nix")
            ./modules/darwin/system
          ];
        };

      # Helper function to generate Home Manager configurations
      # Standardizes user environment setup
      mkHomeConfiguration =
        {
          hostname,
          system ? "x86_64-linux",
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          modules = [
            ./home/common
            (if builtins.match ".*darwin.*" system != null then ./home/darwin else ./home/nixos)
          ];
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Define the systems this flake supports
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake = {
        # NixOS configurations for different machines
        nixosConfigurations = {
          # Configuration for the 'nebula' machine (desktop)
          nebula = mkNixosConfiguration { hostname = "nebula"; };

          # Configuration for the 'comet' machine (laptop)
          comet = mkNixosConfiguration { hostname = "comet"; };

          # Configuration for the 'pulsar' machine (server)
          pulsar = mkNixosConfiguration { hostname = "pulsar"; };
        };

        # Darwin (macOS) configurations
        darwinConfigurations = {
          # Configuration for the 'quasar' macOS machine
          quasar = mkDarwinConfiguration { hostname = "quasar"; };

          # Configuration for the 'meteor' macOS machine
          meteor = mkDarwinConfiguration { hostname = "meteor"; };
        };

        # Home Manager configurations for user-specific setups
        homeConfigurations = {
          # Home Manager configuration for 'nebula' user
          nebula = mkHomeConfiguration { hostname = "nebula"; };

          # Home Manager configuration for 'comet' user
          comet = mkHomeConfiguration { hostname = "comet"; };
        };
      };
    };
}
