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
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # nix darwin
    darwinModules = import ./modules/darwin;

    # NixOS configuration entrypoint
    nixosConfigurations = {
      # Apollo Desktop running on Beelink Ser8
      apollo = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs user;};
        system = "x86_64-linux";
        modules = [
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          ./hosts/nixos/apollo/default.nix
        ];
      };

      # hydra = nixpkgs.lib.nixosSystem {
      #   # Hydra Desktop
      #   specialArgs = {inherit inputs outputs user;};
      #   system = "aarch64-linux";
      #   modules = [
      #     ./hosts/hydra/configuration.nix
      #   ];
      # };
      # Theia Router/Firewall
      # theia = nixpkgs.lib.nixosSystem {
      #   specialArgs = {inherit inputs outputs user;};
      #   system = "x86_64-linux";
      #   modules = [
      #     inputs.disko.nixosModules.disko
      #     ./hosts/theia/configuration.nix
      #   ];
      # };

      # Main Server
      # aurora = nixpkgs.lib.nixosSystem {
      #   specialArgs = {inherit inputs outputs user;};
      #   system = "x86_64-linux";
      #   modules = [
      #     inputs.disko.nixosModules.disko
      #     ./hosts/aurora/configuration.nix
      #   ];
      # };

      # Monitoring (Raspberry Pi)
      # eos = nixpkgs.lib.nixosSystem {
      #   specialArgs = {inherit inputs outputs user;};
      #   system = "aarch64-linux";
      #   modules = [
      #     ./hosts/eos/configuration.nix
      #   ];
      # };
    };

    # Home-manager configurations for deploy-rs
    homeManagerConfigurations = {
      apollo = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs user;};
        modules = [
          inputs.self.homeManagerModules.hyprland
          {
            home = {
              username = "emmet";
              homeDirectory = "/home/emmet";
              stateVersion = "25.05";
            };
            programs.home-manager.enable = true;

            # Enable Hyprland configuration
            hyprland = {
              enable = true;
              terminal = "kitty";
              menu = "wofi --show drun";
              fileManager = "dolphin";
              browser = "firefox";
              editor = "code";
            };
          }
        ];
      };
    };

    # nixDarwinConfigurations = {
    #   "Emmet-Work-Macbook" = inputs.nix-darwin.lib.darwinSystem {
    #     system = "aarch64-darwin";
    #     modules = [
    #       ./hosts/Emmet-Work-Macbook/darwin-configuration.nix
    #     ];
    #     specialArgs = {inherit inputs outputs user;};
    #     pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    #   };
    #   "Emmet-Personal-Macbook" = inputs.nix-darwin.lib.darwinSystem {
    #     system = "aarch64-darwin";
    #     modules = [
    #       ./hosts/Emmet-Personal-Macbook/darwin-configuration.nix
    #     ];
    #     specialArgs = {inherit inputs outputs user;};
    #   };
    # };

    # Remove colmena configuration and add deploy-rs
    deploy.nodes = {
      # theia = {
      #   hostname = "192.168.1.1";
      #   profiles.system = {
      #     sshUser = "nixos-deploy";
      #     user = "root";
      #     sudo = "sudo -u";
      #     sshOpts = [
      #       "-o StrictHostKeyChecking=accept-new"
      #     ];
      #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.theia;
      #     remoteBuild = true;
      #     magicRollback = true;
      #   };
      # };

      apollo = {
        hostname = "192.168.1.103";
        profiles = {
          system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.apollo;
            sshUser = "nixos-deploy";
            sudo = "sudo -u";
            sshOpts = [
              "-o StrictHostKeyChecking=accept-new"
            ];
            remoteBuild = true;
            magicRollback = true;
          };
        };
      };

      # aurora = {
      #   hostname = "192.168.1.132";
      #   profiles.system = {
      #     sshUser = "nixos-deploy";
      #     user = "root";
      #     sudo = "sudo -u";
      #     sshOpts = [
      #       "-o StrictHostKeyChecking=accept-new"
      #     ];
      #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.aurora;
      #     remoteBuild = true;
      #     magicRollback = true;
      #   };
      # };
    };

    # This is highly recommended, to help you catch configuration errors
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
