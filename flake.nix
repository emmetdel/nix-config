{
  description = "Emmet's Nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # nix-darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # deploy-rs
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    deploy-rs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];

    user = "emmet";
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Development shell and packages
    devShells = forAllSystems (system: {
      default = import ./shell.nix {pkgs = nixpkgs.legacyPackages.${system};};
    });

    # Custom packages accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Code formatter for nix files, available through 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom overlays for package modifications and additions
    overlays = import ./overlays {inherit inputs;};

    # Import custom library functions
    lib = import ./lib {inherit inputs outputs;};

    # Reusable modules for different platforms
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    darwinModules = import ./modules/darwin;
    commonModules = import ./modules/common;

    # Reusable profiles
    profiles = import ./profiles;

    # NixOS system configurations
    nixosConfigurations = lib.genNixosConfigs {
      inherit inputs outputs;
      hosts = {
        # Desktop workstation running on Beelink SER8
        apollo = {
          system = "x86_64-linux";
          hostPath = "hosts/nixos/desktop/apollo";
          modules = [
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };

        # Server system
        theia = {
          system = "x86_64-linux";
          hostPath = "hosts/nixos/server/theia";
          modules = [
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };

        # TODO: Add more servers as needed
        # aurora = {
        #   system = "x86_64-linux";
        #   hostPath = "hosts/nixos/server/aurora";
        #   modules = [
        #     disko.nixosModules.disko
        #     sops-nix.nixosModules.sops
        #   ];
        # };

        # Monitoring server (Raspberry Pi)
        # eos = {
        #   system = "aarch64-linux";
        #   hostPath = "hosts/nixos/server/eos";
        #   modules = [
        #     sops-nix.nixosModules.sops
        #   ];
        # };
      };
      user = user;
    };

    # Standalone Home Manager configurations
    homeConfigurations = lib.genHomeConfigs {
      inherit inputs outputs;
      hosts = {
        apollo = {
          system = "x86_64-linux";
          username = user;
          homeDirectory = "/home/${user}";
          hostPath = "hosts/home-manager/apollo";
        };
        # TODO: Add other home configurations as needed
      };
    };

    # macOS system configurations
    darwinConfigurations = lib.genDarwinConfigs {
      inherit inputs outputs;
      hosts = {
        macbook-pro = {
          system = "aarch64-darwin";
          username = user;
          hostPath = "hosts/darwin/macbook-pro";
        };
        macbook-air = {
          system = "aarch64-darwin";
          username = user;
          hostPath = "hosts/darwin/macbook-air";
        };
      };
      user = user;
    };

    # Deployment configuration using deploy-rs
    deploy = lib.genDeployConfig {
      inherit inputs outputs;
      nodes = {
        apollo = {
          hostname = "192.168.1.103";
          system = "x86_64-linux";
        };
        theia = {
          hostname = "192.168.1.1";
          system = "x86_64-linux";
        };
        # TODO: Add more deployment targets as needed
        # aurora = {
        #   hostname = "192.168.1.132";
        #   system = "x86_64-linux";
        # };
      };
    };

    # Deployment checks to catch configuration errors
    checks =
      builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks self.deploy
      )
      deploy-rs.lib;
  };
}
