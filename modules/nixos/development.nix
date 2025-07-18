{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.development;
in {
  options.development = {
    enable = mkEnableOption "Enable development environment";
    languages = {
      nodejs.enable = mkEnableOption "Enable Node.js development";
      python.enable = mkEnableOption "Enable Python development";
      rust.enable = mkEnableOption "Enable Rust development";
      cpp.enable = mkEnableOption "Enable C++ development";
    };
    tools = {
      vscode.enable = mkEnableOption "Enable VS Code";
      neovim.enable = mkEnableOption "Enable Neovim";
      git.enable = mkEnableOption "Enable Git";
    };
  };

  config = mkIf cfg.enable {
    # Add development packages
    environment.systemPackages = with pkgs; [
      # Core development tools
      git
      ripgrep
      fd
      bat
      eza
      fzf
      tmux

      # Language-specific tools
      (mkIf cfg.languages.nodejs.enable nodejs_22)
      (mkIf cfg.languages.python.enable python3)
      (mkIf cfg.languages.rust.enable rustc)
      (mkIf cfg.languages.rust.enable cargo)
      (mkIf cfg.languages.cpp.enable gcc)
      (mkIf cfg.languages.cpp.enable clang)
      (mkIf cfg.languages.cpp.enable cmake)
      (mkIf cfg.languages.cpp.enable ninja)

      # Development environments
      (mkIf cfg.tools.vscode.enable vscode)
      (mkIf cfg.tools.neovim.enable neovim)
    ];
  };
}
