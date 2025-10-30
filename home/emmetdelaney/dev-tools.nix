{ config, pkgs, ... }:

{
  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    extraConfig = ''
      " General settings
      set number
      set relativenumber
      set mouse=a
      set clipboard=unnamedplus
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set smartindent
      set ignorecase
      set smartcase
      set hlsearch
      set incsearch
      set termguicolors
      set cursorline
      set signcolumn=yes
      set updatetime=250
      set completeopt=menuone,noselect
      
      " Better split navigation
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
      
      " Leader key
      let mapleader = " "
      
      " Quick save
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      
      " Clear search highlighting
      nnoremap <leader>h :noh<CR>
      
      " File explorer
      nnoremap <leader>e :Explore<CR>
    '';
    
    plugins = with pkgs.vimPlugins; [
      # Essential plugins
      vim-sensible
      vim-surround
      vim-commentary
      vim-repeat
      vim-fugitive
      
      # UI enhancements
      vim-airline
      vim-airline-themes
      
      # File navigation
      fzf-vim
      
      # Syntax highlighting
      vim-nix
      vim-javascript
      vim-typescript
      vim-json
      vim-markdown
      
      # Colorscheme
      tokyonight-nvim
    ];
  };
  
  # GitHub CLI configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
    };
  };
  
  # Tmux configuration
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    baseIndex = 1;
    
    extraConfig = ''
      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
      
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      # Better pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # Status bar
      set -g status-style 'bg=#1a1b26 fg=#c0caf5'
      set -g status-left '#[fg=#7aa2f7,bold] #S '
      set -g status-right '#[fg=#9ece6a] %Y-%m-%d %H:%M '
      
      # Window status
      set -g window-status-current-style 'fg=#7dcfff,bold'
      set -g window-status-style 'fg=#565f89'
      
      # Pane borders
      set -g pane-border-style 'fg=#565f89'
      set -g pane-active-border-style 'fg=#7aa2f7'
      
      # Enable true color
      set -ga terminal-overrides ",*256col*:Tc"
      
      # Enable focus events
      set -g focus-events on
      
      # Don't rename windows automatically
      set -g allow-rename off
    '';
    
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
    ];
  };
  
  # Lazygit configuration
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          activeBorderColor = ["#7aa2f7" "bold"];
          inactiveBorderColor = ["#565f89"];
          selectedLineBgColor = ["#292e42"];
        };
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
  
  # Git delta for better diffs
  programs.git.delta = {
    enable = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "TwoDark";
    };
  };
  
  # Yazi (terminal file manager) configuration
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
  
  # Additional Git configuration
  programs.git = {
    enable = true;
    userName = "Emmet Delaney";
    userEmail = "emmetdel@gmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
    };
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "log --graph --oneline --all";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };
}

