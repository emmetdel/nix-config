{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Nix tooling
    nixpkgs-fmt # Nix code formatter
    nil # Nix language server
    alejandra # Alternative Nix formatter

    # Development tools
    # git
    # vim
    # just
    # cowsay
  ];

  shellHook = ''
    echo "Welcome to the NixOS config development environment!"
    echo "Available tools:"
    echo " - nixpkgs-fmt: Format Nix code"
    echo " - nil: Nix language server"
    echo " - alejandra: Alternative Nix formatter"
    echo " - nix-fmt: Nix formatter"
  '';
}
