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
      rebuild = "sudo nixos-rebuild switch --flake ~/code/personal/nix-config#helios";
      update = "nix flake update ~/code/personal/nix-config";
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
      
      # Modern replacements
      ls = "eza --icons";
      ll = "eza -la --icons";
      tree = "eza --tree --icons";
      
      # Editor
      vim = "nvim";
      vi = "nvim";
    };
    
    initContent = ''
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
      
      format = "$directory$git_branch$git_status$character";
      
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
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕";
        modified = "!";
        staged = "+";
        deleted = "✘";
      };
    };
  };
  
  # Eza (modern ls replacement)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };
  
  # Git configuration
  programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "Emmet Delaney";
        email = "emmetdel@gmail.com";
      };
      
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
      };
    };
  };
  
  # Work git configuration
  xdg.configFile."git/config-work".text = ''
    [user]
      name = Emmet Delaney
      email = emmet.delaney@sitenna.com
  '';
}
