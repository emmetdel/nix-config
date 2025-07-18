# Custom library functions for the dotfiles flake
{
  inputs,
  outputs,
}: let
  inherit (inputs.nixpkgs) lib;
in {
  # Generate NixOS configurations from a hosts attribute set
  genNixosConfigs = {
    inputs,
    outputs,
    hosts,
    user,
  }:
    lib.mapAttrs (
      hostname: hostConfig:
        inputs.nixpkgs.lib.nixosSystem {
          system = hostConfig.system;
          specialArgs = {inherit inputs outputs user;};
          modules =
            [
              # Always include the host-specific configuration
              ../hosts/nixos/${hostname}
            ]
            ++ (hostConfig.modules or []);
        }
    )
    hosts;

  # Generate Home Manager configurations from a hosts attribute set
  genHomeConfigs = {
    inputs,
    outputs,
    hosts,
  }:
    lib.mapAttrs (
      hostname: hostConfig:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${hostConfig.system};
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            # Include host-specific home configuration if it exists
            ../hosts/home-manager/${hostname}
            {
              home = {
                username = hostConfig.username;
                homeDirectory = hostConfig.homeDirectory;
                stateVersion = "25.05";
              };
              programs.home-manager.enable = true;
            }
          ];
        }
    )
    hosts;

  # Generate Darwin configurations from a hosts attribute set
  genDarwinConfigs = {
    inputs,
    outputs,
    hosts,
    user,
  }:
    lib.mapAttrs (
      hostname: hostConfig:
        inputs.nix-darwin.lib.darwinSystem {
          system = hostConfig.system;
          specialArgs = {inherit inputs outputs user;};
          modules =
            [
              # Include host-specific darwin configuration
              ../hosts/darwin/${hostname}
            ]
            ++ (hostConfig.modules or []);
        }
    )
    hosts;

  # Generate deploy-rs configuration from a nodes attribute set
  genDeployConfig = {
    inputs,
    outputs,
    nodes,
  }: {
    nodes =
      lib.mapAttrs (
        hostname: nodeConfig: {
          hostname = nodeConfig.hostname;
          profiles.system = {
            user = "root";
            sshUser = "nixos-deploy";
            sudo = "sudo -u";
            sshOpts = [
              "-o StrictHostKeyChecking=accept-new"
            ];
            path =
              inputs.deploy-rs.lib.${nodeConfig.system}.activate.nixos
              outputs.nixosConfigurations.${hostname};
            remoteBuild = true;
            magicRollback = true;
          };
        }
      )
      nodes;
  };

  # Helper function to create a system configuration template
  mkSystem = {
    system,
    hostname,
    modules ? [],
    extraSpecialArgs ? {},
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs outputs;} // extraSpecialArgs;
      modules =
        [
          ../hosts/nixos/${hostname}
        ]
        ++ modules;
    };

  # Helper function to create a home configuration template
  mkHome = {
    system,
    username,
    homeDirectory,
    modules ? [],
    extraSpecialArgs ? {},
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {inherit inputs outputs;} // extraSpecialArgs;
      modules =
        [
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "25.05";
            };
            programs.home-manager.enable = true;
          }
        ]
        ++ modules;
    };
}
