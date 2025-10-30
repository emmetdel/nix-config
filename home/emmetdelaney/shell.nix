{ config, pkgs, ... }:

{
  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      share = true;
    };
    
    shellAliases = {
      # System management
      rebuild = "sudo nixos-rebuild switch --flake ~/personal-code/nix-config#helios";
      update = "nix flake update ~/personal-code/nix-config";
      cleanup = "sudo nix-collect-garbage -d";
      
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      
      # Modern replacements
      ls = "eza --icons";
      ll = "eza -la --icons";
      tree = "eza --tree --icons";
      cat = "bat";
      find = "fd";
      grep = "rg";
      
      # Productivity
      vim = "nvim";
      vi = "nvim";
    };
    
    initExtra = ''
      # Enable vi mode
      bindkey -v
      
      # Better completion
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      
      # Better history search
      bindkey '^R' history-incremental-search-backward
      bindkey '^P' up-line-or-search
      bindkey '^N' down-line-or-search
    '';
  };
  
  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      
      format = "$username$hostname$directory$git_branch$git_status$character";
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };
      
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      
      git_status = {
        style = "bold yellow";
        conflicted = "🏳";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };
      
      nodejs = {
        symbol = " ";
        style = "bold green";
      };
      
      python = {
        symbol = " ";
        style = "bold yellow";
      };
      
      rust = {
        symbol = " ";
        style = "bold red";
      };
    };
  };
  
  # Direnv for per-directory environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  
  # Zoxide for smart directory jumping
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  
  # FZF for fuzzy finding
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
    colors = {
      bg = "#1a1b26";
      "bg+" = "#292e42";
      fg = "#c0caf5";
      "fg+" = "#c0caf5";
      hl = "#7aa2f7";
      "hl+" = "#7dcfff";
      info = "#7aa2f7";
      prompt = "#7dcfff";
      pointer = "#7dcfff";
      marker = "#9ece6a";
      spinner = "#9ece6a";
      header = "#9ece6a";
    };
  };
  
  # Eza (modern ls replacement)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = true;
  };
  
  # Bat (modern cat replacement)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "numbers,changes,header";
    };
  };
  
  # Ripgrep configuration
  programs.ripgrep = {
    enable = true;
  };
}

