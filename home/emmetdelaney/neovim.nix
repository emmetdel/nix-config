{
  config,
  pkgs,
  ...
}: {
  # Enhanced Neovim configuration with LSP and plugins
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Configure Neovim with plugins and settings
    configure = {
      customRC = ''
        " Tokyo Night theme
        set termguicolors
        colorscheme tokyonight

        " Basic settings
        set number
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set smartindent
        set wrap
        set linebreak
        set mouse=a
        set clipboard=unnamedplus
        set ignorecase
        set smartcase
        set incsearch
        set hlsearch
        set showmatch
        set wildmenu
        set wildmode=longest:full,full

        " Leader key
        let mapleader = " "

        " Better navigation
        nnoremap j gj
        nnoremap k gk
        nnoremap <C-h> <C-w>h
        nnoremap <C-j> <C-w>j
        nnoremap <C-k> <C-w>k
        nnoremap <C-l> <C-w>l

        " Quick save/quit
        nnoremap <leader>w :w<CR>
        nnoremap <leader>q :q<CR>
        nnoremap <leader>x :x<CR>

        " Clear search highlighting
        nnoremap <leader>c :nohlsearch<CR>

        " Buffer navigation
        nnoremap <leader>n :bnext<CR>
        nnoremap <leader>p :bprevious<CR>
        nnoremap <leader>d :bdelete<CR>

        " LSP keybindings (when LSP is available)
        nnoremap <leader>gd :lua vim.lsp.buf.definition()<CR>
        nnoremap <leader>gr :lua vim.lsp.buf.references()<CR>
        nnoremap <leader>gi :lua vim.lsp.buf.implementation()<CR>
        nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>
        nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
        nnoremap <leader>ff :lua vim.lsp.buf.format()<CR>
        nnoremap <leader>e :lua vim.diagnostic.open_float()<CR>
        nnoremap <leader>dn :lua vim.diagnostic.goto_next()<CR>
        nnoremap <leader>dp :lua vim.diagnostic.goto_prev()<CR>

        " Telescope keybindings (when available)
        nnoremap <leader>tf :lua require('telescope.builtin').find_files()<CR>
        nnoremap <leader>tg :lua require('telescope.builtin').live_grep()<CR>
        nnoremap <leader>tb :lua require('telescope.builtin').buffers()<CR>
        nnoremap <leader>th :lua require('telescope.builtin').help_tags()<CR>
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          # Theme
          tokyonight-nvim

          # LSP and completion
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          luasnip
          cmp_luasnip

          # Treesitter
          nvim-treesitter.withAllGrammars

          # Fuzzy finding
          telescope-nvim
          telescope-fzf-native-nvim

          # File explorer
          nvim-tree-lua

          # Git integration
          gitsigns-nvim

          # Status line
          lualine-nvim

          # Essential utilities
          plenary-nvim
          popup-nvim
          which-key-nvim
        ];
      };
    };

    # Extra packages for Neovim
    extraPackages = with pkgs; [
      # LSP servers
      nixd # Nix LSP
      lua-language-server
      pyright # Python LSP
      gopls # Go LSP
      rust-analyzer
      clang-tools # C/C++ LSP

      # Formatters and linters
      alejandra # Nix formatter
      black # Python formatter
      gofmt # Go formatter
      rustfmt # Rust formatter
      clang-tools # C/C++ tools

      # Additional tools
      ripgrep # For telescope live grep
      fd # For telescope find files
    ];
  };

  # Tokyo Night theme for Neovim
  home.file.".config/nvim/lua/tokyonight.lua".text = ''
    require('tokyonight').setup({
      style = 'night',
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = 'dark',
        floats = 'dark',
      },
      sidebars = { 'qf', 'help' },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    })
  '';

  # LSP configuration
  home.file.".config/nvim/lua/lsp.lua".text = ''
    local lspconfig = require('lspconfig')

    -- Setup LSP servers
    local servers = { 'nixd', 'pyright', 'gopls', 'rust_analyzer', 'clangd' }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }
    end

    -- LSP keybindings are set in init.vim
  '';

  # Completion configuration
  home.file.".config/nvim/lua/cmp.lua".text = ''
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      })
    })
  '';

  # Treesitter configuration
  home.file.".config/nvim/lua/treesitter.lua".text = ''
    require('nvim-treesitter.configs').setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      ensure_installed = {
        'nix',
        'lua',
        'python',
        'go',
        'rust',
        'c',
        'cpp',
        'javascript',
        'typescript',
        'html',
        'css',
        'json',
        'yaml',
        'toml',
        'bash',
        'vim',
      },
    })
  '';

  # Telescope configuration
  home.file.".config/nvim/lua/telescope.lua".text = ''
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    })

    -- Enable telescope fzf native
    require('telescope').load_extension('fzf')
  '';

  # Lualine configuration
  home.file.".config/nvim/lua/lualine.lua".text = ''
    require('lualine').setup({
      options = {
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = "",
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    })
  '';

  # Gitsigns configuration
  home.file.".config/nvim/lua/gitsigns.lua".text = ''
    require('gitsigns').setup({
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    })
  '';
}
