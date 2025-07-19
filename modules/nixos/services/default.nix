{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dotfiles.services;
in {
  options.dotfiles.services = {
    # Service enablement options
    enablePipewire = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Pipewire";
    };

    enableFlatpak = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Flatpak";
    };

    enablePrinting = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable printing";
    };

    # Flatpak packages
    flatpakPackages = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["org.gimp.GIMP" "com.spotify.Client"];
      description = "List of Flatpak packages to install";
    };
  };

  config = {
    # Enable services based on configuration
    services.pipewire.enable = cfg.enablePipewire;
    services.flatpak.enable = cfg.enableFlatpak;
    services.printing.enable = cfg.enablePrinting;

    # Flatpak applications
    services.flatpak.packages = cfg.flatpakPackages;
  };
}
