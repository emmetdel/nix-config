# Complete Keybindings Reference

## 🪟 Hyprland Window Manager

### Core Actions
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super + Return` | Launch Terminal | Opens Kitty terminal |
| `Super + Q` | Kill Window | Closes the active window |
| `Super + M` | Exit Hyprland | Logs out of the session |
| `Super + L` | Lock Screen | Locks screen with Swaylock |

### Window Controls
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super + V` | Toggle Floating | Makes window float/tile |
| `Super + F` | Toggle Fullscreen | Fullscreen active window |
| `Super + P` | Pseudo Tile | Pseudo-tiling mode |
| `Super + J` | Toggle Split | Toggle split direction |

### Window Navigation (Vim Keys)
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super + H` | Focus Left | Move focus left |
| `Super + J` | Focus Down | Move focus down |
| `Super + K` | Focus Up | Move focus up |
| `Super + L` | Focus Right | Move focus right |

### Window Navigation (Arrow Keys)
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super + ←` | Focus Left | Move focus left |
| `Super + ↓` | Focus Down | Move focus down |
| `Super + ↑` | Focus Up | Move focus up |
| `Super + →` | Focus Right | Move focus right |

### Workspace Management
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super + 1-9,0` | Switch Workspace | Go to workspace 1-10 |
| `Super + Shift + 1-9,0` | Move to Workspace | Move window to workspace 1-10 |
| `Super + Mouse Wheel` | Cycle Workspaces | Scroll through workspaces |
| `Super + S` | Toggle Scratchpad | Show/hide scratchpad |
| `Super + Shift + S` | Move to Scratchpad | Send window to scratchpad |

### Mouse Actions
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super + Left Click` | Move Window | Drag to move window |
| `Super + Right Click` | Resize Window | Drag to resize window |

## 🚀 Application Launchers

### Quick Launch
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super + D` | App Launcher | Rofi application launcher |
| `Super + R` | Run Command | Rofi run dialog |
| `Super + E` | File Manager | Opens Thunar (GUI) |
| `Super + Shift + E` | Terminal FM | Opens Yazi in terminal |
| `Super + Shift + B` | Browser | Opens Firefox |
| `Super + Shift + C` | Code Editor | Opens VSCode/Cursor |
| `Super + W` | Web Apps | Custom web apps launcher |

## 🛠️ Utilities

### Productivity Tools
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Super + Shift + V` | Clipboard History | Browse clipboard history |
| `Super + C` | Color Picker | Pick color from screen |
| `Print` | Area Screenshot | Screenshot selected area |
| `Shift + Print` | Full Screenshot | Screenshot entire screen |

## 📟 Terminal (Kitty)

### Basic Controls
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + Shift + C` | Copy | Copy selected text |
| `Ctrl + Shift + V` | Paste | Paste from clipboard |
| `Ctrl + Shift + T` | New Tab | Open new tab |
| `Ctrl + Shift + W` | Close Tab | Close current tab |
| `Ctrl + Shift + ←/→` | Switch Tab | Navigate between tabs |
| `Ctrl + Shift + +` | Increase Font | Zoom in |
| `Ctrl + Shift + -` | Decrease Font | Zoom out |

## 🖥️ Tmux

### Session Management
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + A` | Prefix | Tmux command prefix |
| `Prefix + D` | Detach | Detach from session |
| `Prefix + $` | Rename Session | Rename current session |

### Window Management
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + C` | New Window | Create new window |
| `Prefix + N` | Next Window | Go to next window |
| `Prefix + P` | Previous Window | Go to previous window |
| `Prefix + 0-9` | Select Window | Go to window by number |
| `Prefix + ,` | Rename Window | Rename current window |
| `Prefix + &` | Kill Window | Close current window |

### Pane Management
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + \|` | Split Vertical | Split pane vertically |
| `Prefix + -` | Split Horizontal | Split pane horizontally |
| `Prefix + H` | Go Left | Move to left pane |
| `Prefix + J` | Go Down | Move to bottom pane |
| `Prefix + K` | Go Up | Move to top pane |
| `Prefix + L` | Go Right | Move to right pane |
| `Prefix + Shift + H` | Resize Left | Make pane wider left |
| `Prefix + Shift + J` | Resize Down | Make pane taller |
| `Prefix + Shift + K` | Resize Up | Make pane shorter |
| `Prefix + Shift + L` | Resize Right | Make pane wider right |
| `Prefix + X` | Kill Pane | Close current pane |

### Copy Mode
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + [` | Enter Copy Mode | Start copy mode |
| `Space` | Start Selection | Begin selecting text |
| `Enter` | Copy Selection | Copy and exit |
| `v` | Visual Mode | Start visual selection |
| `y` | Yank | Copy to clipboard |
| `q` | Quit | Exit copy mode |

## 📝 Neovim

### Basic Commands
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Space` | Leader Key | Command prefix |
| `Leader + W` | Save | Save current file |
| `Leader + Q` | Quit | Close current buffer |
| `Leader + H` | Clear Search | Clear search highlights |
| `Leader + E` | File Explorer | Open file explorer |

### Navigation
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + H` | Window Left | Move to left split |
| `Ctrl + J` | Window Down | Move to bottom split |
| `Ctrl + K` | Window Up | Move to top split |
| `Ctrl + L` | Window Right | Move to right split |

## 🐚 Shell (Zsh)

### History Navigation
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + R` | Search History | Reverse search history |
| `Ctrl + P` | Previous Command | Navigate history up |
| `Ctrl + N` | Next Command | Navigate history down |
| `↑/↓` | History Search | Search by current input |

### Useful Aliases
| Command | Action | Description |
|---------|--------|-------------|
| `rebuild` | Rebuild System | nixos-rebuild switch |
| `update` | Update Flakes | Update flake.lock |
| `cleanup` | Clean System | Remove old generations |
| `g` | Git | Git shorthand |
| `gs` | Git Status | Show git status |
| `ga` | Git Add | Stage files |
| `gc` | Git Commit | Commit changes |
| `gp` | Git Push | Push to remote |
| `gl` | Git Pull | Pull from remote |
| `ll` | List Files | ls with details and icons |
| `tree` | Directory Tree | Show directory structure |

### Directory Navigation
| Command | Action | Description |
|---------|--------|-------------|
| `z <dir>` | Jump to Directory | Smart directory jump |
| `..` | Parent Directory | Go up one level |
| `...` | 2x Parent | Go up two levels |
| `....` | 3x Parent | Go up three levels |

## 🎨 Rofi

### Navigation
| Keybinding | Action | Description |
|------------|--------|-------------|
| `↑/↓` | Navigate | Move selection |
| `Enter` | Select | Launch selected app |
| `Esc` | Cancel | Close launcher |
| `Ctrl + J/K` | Navigate | Alternative navigation |
| `Tab` | Switch Mode | Switch between modes |

## 🔍 FZF (Fuzzy Finder)

### In Terminal
| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + T` | File Search | Find and insert file path |
| `Ctrl + R` | Command History | Search command history |
| `Alt + C` | Directory Search | Find and cd to directory |
| `↑/↓` | Navigate | Move selection |
| `Enter` | Select | Choose item |
| `Esc` | Cancel | Exit search |

## 💻 Git (Lazygit)

### Basic Navigation
| Keybinding | Action | Description |
|------------|--------|-------------|
| `1-5` | Switch Panel | Navigate main panels |
| `J/K` | Move Selection | Navigate items |
| `Enter` | View/Edit | Open selected item |
| `Space` | Stage/Unstage | Toggle staging |
| `C` | Commit | Commit staged changes |
| `P` | Push | Push to remote |
| `p` | Pull | Pull from remote |
| `q` | Quit | Exit lazygit |

## 🌐 Web Apps Launcher

Access these through `Super + W`:
- Gmail
- Google Calendar
- GitHub
- ChatGPT
- Claude AI
- Linear
- Notion
- Figma

---

**Pro Tip**: Print this reference or keep it handy while learning the keybindings. They'll become second nature quickly!

