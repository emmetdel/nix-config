{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gc = {
    enable = lib.mkEnableOption "Enable garbage collection configuration";
  };

  config = lib.mkIf config.gc.enable {
    # Configure Nix garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      options = "--delete-older-than 30d";
    };
    nix.settings.auto-optimise-store = true;
  };
}
