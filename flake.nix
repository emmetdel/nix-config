{
  description = "Emmet's NixOS configuration with Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    sops-nix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      helios = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # Host configuration
          ./hosts/helios/default.nix

          # Secrets management (temporarily disabled)
          # sops-nix.nixosModules.sops

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              backupFileExtension = "backup";
              users.emmetdelaney = import ./home/emmetdelaney/default.nix;
            };
          }
        ];
      };
    };

    # Development shell for Linux (NixOS)
    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs {system = "x86_64-linux";};
    in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra # Nix formatter
          nixd # Nix LSP for IntelliSense
          statix # Nix linter
          deadnix # Find dead/unused Nix code
          sops # Secrets management
          age # Encryption for sops
        ];

        shellHook = ''
          echo "🔧 NixOS Config Development Environment"
          echo ""
          echo "Available commands:"
          echo "  alejandra .          - Format all Nix files"
          echo "  alejandra -c .       - Check formatting (no changes)"
          echo "  statix check .       - Lint Nix files"
          echo "  deadnix .            - Find unused code"
          echo "  nix flake check      - Validate flake"
          echo ""
        '';
      };

    # Development shell for macOS (Intel)
    devShells.x86_64-darwin.default = let
      pkgs = import nixpkgs {system = "x86_64-darwin";};
    in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra # Nix formatter
          nixd # Nix LSP for IntelliSense
          statix # Nix linter
          deadnix # Find dead/unused Nix code
          sops # Secrets management
          age # Encryption for sops
        ];

        shellHook = ''
          echo "🔧 NixOS Config Development Environment"
          echo ""
          echo "Available commands:"
          echo "  alejandra .          - Format all Nix files"
          echo "  alejandra -c .       - Check formatting (no changes)"
          echo "  statix check .       - Lint Nix files"
          echo "  deadnix .            - Find unused code"
          echo "  nix flake check      - Validate flake"
          echo ""
        '';
      };

    # Alias for aarch64-darwin (Apple Silicon)
    devShells.aarch64-darwin.default = self.devShells.x86_64-darwin.default;
  };
}
