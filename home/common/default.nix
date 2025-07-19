{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dotfiles.home;
  # Import the centralized package definitions
  allPackages = import ../../modules/packages.nix {inherit pkgs;};
in {
  options.dotfiles.home = {
    # Package selection options
    enableCliTools = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to install CLI tools";
    };

    enableDevelopment = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to install development tools";
    };

    enableDesktop = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to install desktop applications";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional packages to install";
    };
  };

  config = {
    # Install user-specific packages based on configuration
    home.packages =
      (
        if cfg.enableCliTools
        then allPackages.all-packages.cli-tools
        else []
      )
      ++ (
        if cfg.enableDevelopment
        then allPackages.all-packages.development
        else []
      )
      ++ (
        if cfg.enableDesktop
        then allPackages.all-packages.desktop
        else []
      )
      ++ cfg.extraPackages;

    # Enable home-manager
    programs.home-manager.enable = true;

    # Default shell configuration
    programs.bash.enable = true;
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "docker" "npm" "python"];
        theme = "robbyrussell";
      };
    };

    # Git configuration
    programs.git = {
      enable = true;
      userName = mkDefault "Emmet Delaney";
      userEmail = mkDefault "emmet@example.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };

    # Default editor configuration
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };
}
