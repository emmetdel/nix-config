{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dotfiles.packages;
  # Import the centralized package definitions
  allPackages = import ../../packages.nix {inherit pkgs;};
in {
  options.dotfiles.packages = {
    # Package selection options
    enableCore = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to install core system packages";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional packages to install";
    };
  };

  config = {
    # Install core system packages if enabled
    environment.systemPackages =
      (
        if cfg.enableCore
        then allPackages.all-packages.core
        else []
      )
      ++ cfg.extraPackages;
  };
}
