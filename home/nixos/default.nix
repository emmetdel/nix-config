{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dotfiles.home.nixos;
in {
  options.dotfiles.home.nixos = {
    # NixOS-specific home configuration options
    enableXdgIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable XDG directory integration";
    };

    enableFontConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable font configuration";
    };
  };

  config = {
    # XDG directories configuration
    xdg = mkIf cfg.enableXdgIntegration {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };

    # Font configuration
    fonts.fontconfig.enable = cfg.enableFontConfig;

    # NixOS-specific shell aliases
    programs.bash.shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nixos-rebuild switch --upgrade";
    };

    programs.zsh.shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nixos-rebuild switch --upgrade";
    };

    # NixOS-specific environment variables
    home.sessionVariables = {
      NIXOS_CONFIG = "$HOME/.dotfiles";
    };
  };
}
