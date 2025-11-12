{
  config,
  pkgs,
  ...
}: {
  # Enhanced VSCode configuration with productivity extensions
  programs.vscode = {
    enable = true;

    # Code-managed extensions (disabled for now - can be added back when availability is confirmed)
    extensions = [];

    # VSCode settings
    userSettings = {
      # Tokyo Night theme
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.iconTheme" = "vs-seti";

      # Editor settings
      "editor.fontFamily" = "JetBrainsMono Nerd Font, monospace";
      "editor.fontSize" = 14;
      "editor.lineHeight" = 1.6;
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.detectIndentation" = false;
      "editor.renderWhitespace" = "boundary";
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.smoothScrolling" = true;
      "editor.minimap.enabled" = false;
      "editor.scrollBeyondLastLine" = false;
      "editor.wordWrap" = "on";
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;

      # Terminal settings
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      "terminal.integrated.fontSize" = 14;
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.cursorStyle" = "line";
      "terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";

      # Vim mode settings
      "vim.useSystemClipboard" = true;
      "vim.hlsearch" = true;
      "vim.incsearch" = true;
      "vim.useCtrlKeys" = true;
      "vim.handleKeys" = {
        "<C-d>" = true;
        "<C-c>" = false;
      };

      # File associations
      "files.associations" = {
        "*.nix" = "nix";
        "flake.lock" = "json";
      };

      # Git settings
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "git.autofetch" = true;

      # Language-specific settings
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };

      "[python]" = {
        "editor.defaultFormatter" = "ms-python.black-formatter";
        "editor.formatOnSave" = true;
      };

      "[go]" = {
        "editor.defaultFormatter" = "golang.go";
        "editor.formatOnSave" = true;
      };

      "[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        "editor.formatOnSave" = true;
      };

      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnSave" = true;
      };

      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnSave" = true;
      };

      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnSave" = true;
      };

      "[yaml]" = {
        "editor.defaultFormatter" = "redhat.vscode-yaml";
        "editor.formatOnSave" = true;
      };

      # Prettier settings
      "prettier.configPath" = "";
      "prettier.useEditorConfig" = true;

      # Nix IDE settings
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";

      # Go settings
      "go.useLanguageServer" = true;
      "go.formatTool" = "gofmt";
      "go.lintTool" = "golint";

      # Python settings
      "python.defaultInterpreterPath" = "python3";
      "python.linting.enabled" = true;
      "python.linting.pylintEnabled" = true;
      "python.formatting.provider" = "black";

      # Window settings
      "window.titleBarStyle" = "custom";
      "window.zoomLevel" = 0;

      # Workbench settings
      "workbench.editor.enablePreview" = false;
      "workbench.editor.showTabs" = "multiple";
      "workbench.activityBar.visible" = true;
      "workbench.statusBar.visible" = true;
      "workbench.sideBar.location" = "left";

      # Search settings
      "search.exclude" = {
        "**/node_modules" = true;
        "**/.git" = true;
        "**/.DS_Store" = true;
        "**/dist" = true;
        "**/build" = true;
      };

      # Extensions settings
      "extensions.ignoreRecommendations" = true;

      # Telemetry
      "telemetry.telemetryLevel" = "off";
    };

    # Keybindings
    keybindings = [
      {
        key = "ctrl+shift+p";
        command = "workbench.action.showCommands";
      }
      {
        key = "ctrl+p";
        command = "workbench.action.quickOpen";
      }
      {
        key = "ctrl+shift+f";
        command = "workbench.action.findInFiles";
      }
      {
        key = "ctrl+tab";
        command = "workbench.action.nextEditor";
      }
      {
        key = "ctrl+shift+tab";
        command = "workbench.action.previousEditor";
      }
      {
        key = "ctrl+w";
        command = "workbench.action.closeActiveEditor";
      }
      {
        key = "ctrl+shift+t";
        command = "workbench.action.reopenClosedEditor";
      }
      {
        key = "ctrl+`";
        command = "workbench.action.terminal.toggleTerminal";
      }
    ];
  };
}
