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
  } @ inputs: let
    # Centralized user configuration
    userConfig = {
      username = "emmetdelaney";
      fullName = "Emmet Delaney";
      email = {
        personal = "emmetdel@gmail.com";
        work = "emmet.delaney@sitenna.com";
      };
    };

    # Centralized host configuration
    hostConfig = {
      helios = {
        hostname = "helios";
        system = "x86_64-linux";
      };
    };
  in {
    nixosConfigurations = {
      helios = nixpkgs.lib.nixosSystem {
        system = hostConfig.helios.system;
        specialArgs = {
          inherit inputs userConfig;
          hostname = hostConfig.helios.hostname;
        };
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

    # Common shell hook for development environments
    lib.mkShellHook = ''
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

    # Common dev tools for all platforms
    lib.mkDevShell = pkgs:
      pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra # Nix formatter
          nixd # Nix LSP for IntelliSense
          statix # Nix linter
          deadnix # Find dead/unused Nix code
          sops # Secrets management
          age # Encryption for sops
        ];

        shellHook = self.lib.mkShellHook;
      };

    # Development shell for Linux (NixOS)
    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs {system = "x86_64-linux";};
    in
      self.lib.mkDevShell pkgs;

    # Development shell for macOS (Intel)
    devShells.x86_64-darwin.default = let
      pkgs = import nixpkgs {system = "x86_64-darwin";};
    in
      self.lib.mkDevShell pkgs;

    # Alias for aarch64-darwin (Apple Silicon)
    devShells.aarch64-darwin.default = self.devShells.x86_64-darwin.default;
  };
}
