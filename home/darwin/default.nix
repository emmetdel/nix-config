{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dotfiles.home.darwin;
in {
  options.dotfiles.home.darwin = {
    # Darwin-specific home configuration options
    enableMacOSIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable macOS integration";
    };

    enableHomebrewIntegration = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Homebrew integration";
    };
  };

  config = {
    # macOS-specific shell aliases
    programs.bash.shellAliases = mkIf cfg.enableMacOSIntegration {
      rebuild = "darwin-rebuild switch";
      update = "darwin-rebuild switch --upgrade";
    };

    programs.zsh.shellAliases = mkIf cfg.enableMacOSIntegration {
      rebuild = "darwin-rebuild switch";
      update = "darwin-rebuild switch --upgrade";
    };

    # macOS-specific environment variables
    home.sessionVariables = mkIf cfg.enableMacOSIntegration {
      DARWIN_CONFIG = "$HOME/.dotfiles";
    };

    # Homebrew integration
    homebrew = mkIf cfg.enableHomebrewIntegration {
      enable = true;
      onActivation = {
        autoUpdate = true;
        cleanup = "zap";
      };
      global = {
        brewfile = true;
      };
      taps = [
        "homebrew/cask"
        "homebrew/cask-fonts"
      ];
      casks = [
        "iterm2"
        "visual-studio-code"
      ];
    };
  };
}
