({
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      grep = "grep --color=auto";
      nixos-rebuild = "sudo nixos-rebuild";
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      # Hyprland specific
      screenshot = "grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png";
      screenrec = "wf-recorder -g \"$(slurp)\" -f ~/Videos/recording-$(date +%Y%m%d_%H%M%S).mp4";
    };

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "docker" "node" "npm" "rust" "golang"];
      theme = "robbyrussell";
    };
  };
})
