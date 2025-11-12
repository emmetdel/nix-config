# NixOS Developer Productivity Setup - Improvement Plan

## Current State Analysis

### Strengths
- **Minimal & Focused**: ~20 packages, single Tokyo Night theme, web-first philosophy
- **Hyprland WM**: Modern Wayland compositor with good keyboard shortcuts
- **Web Apps**: PWA support for Gmail, Calendar, Linear, Notion, ChatGPT
- **Basic Tools**: Kitty terminal, Zsh + Starship, Neovim, VSCode, Git
- **Keyboard-Centric**: Vim-style navigation, app launchers, window management
- **Browser Strategy**: LibreWolf for personal browsing, ungoogled-chromium for web apps

### Current Gaps & Issues

#### Keyboard Productivity
- Limited shortcuts for developer workflows (build, test, deploy)
- No global search/replace shortcuts
- Missing media controls integration
- No quick terminal dropdown
- Limited clipboard management

#### Development Environment
- Basic Neovim config (no plugins or LSP)
- VSCode without productivity extensions
- No development servers or tools
- Missing language-specific tooling
- No container/VM management

#### Security & Authentication
- SSH agent not auto-started
- No FIDO/U2F for sudo
- Password managers not integrated
- No hardware security keys support

#### Work/Personal Separation
- No work profile isolation
- Single browser profile for all apps
- No separate work apps/web apps
- Git config switching incomplete

#### UI/UX Polish
- Login screen not themed
- Lockscreen basic styling
- Notifications could be more actionable
- No system tray organization

#### Missing Tools
- No fuzzy finding beyond Rofi
- Limited file management shortcuts
- No quick notes/task management
- Missing productivity apps

## Improvement Priorities

### High Priority (Essential for Productivity)

#### 1. Enhanced Keyboard Shortcuts
- **Terminal Dropdown**: `Super + Grave` for quick terminal access
- **Global Search**: `Super + /` for system-wide content search
- **App Switching**: `Super + Tab` for window switching
- **Workspace Navigation**: Better workspace cycling
- **Media Controls**: Dedicated media control shortcuts

#### 2. Development Tooling
- **Neovim Enhancement**: Add LSP, treesitter, telescope, and essential plugins
- **VSCode Extensions**: Productivity extensions (vim mode, git, etc.)
- **Language Support**: Go, Python, Nix development tools
- **Build/Test Shortcuts**: Quick commands for common dev tasks

#### 3. Security & Authentication
- **SSH Agent**: Auto-start with key loading
- **FIDO U2F**: Hardware key support for sudo
- **Password Managers**: Bitwarden/1Password integration
- **Hardware Security**: YubiKey support

#### 4. Work/Personal Profiles
- **Browser Profiles**: Separate work/personal ungoogled-chromium profiles
- **Web Apps**: Work-specific PWAs (Outlook, Teams, Slack) in work profile
- **Personal Browser**: LibreWolf for personal browsing
- **Git Config**: Automatic switching based on directory
- **Environment Variables**: Profile-specific settings
- **Code-Configured**: All extensions, settings, and preferences managed through Nix

### Medium Priority (Quality of Life)

#### 5. UI/UX Enhancements
- **Login Screen**: Tokyo Night themed SDDM
- **Lockscreen**: Better styling and animations
- **Notifications**: Actionable notifications with keyboard shortcuts
- **System Tray**: Organized and minimal

#### 6. Additional Tools
- **Fuzzy Finding**: Enhanced search capabilities
- **Clipboard Manager**: History and management
- **Quick Notes**: Fast note-taking system
- **Task Management**: Integration with task tools

#### 7. Automation & Scripts
- **Backup Scripts**: Automated backup solutions
- **Update Automation**: Smart update notifications
- **Environment Setup**: Quick dev environment switching
- **Productivity Scripts**: Common workflow automations

### Low Priority (Polish & Advanced Features)

#### 8. Advanced Features
- **Window Management**: Better tiling layouts
- **Multi-Monitor**: Enhanced multi-display support
- **Power Management**: Smart power profiles
- **Backup Integration**: Cloud backup solutions

#### 9. Ecosystem Integration
- **Mobile Sync**: Phone integration
- **Cloud Services**: Drive, Photos, etc.
- **Collaboration Tools**: Enhanced communication setup

## Code-Based Configuration Philosophy

All aspects of the system should be configured through code wherever possible:
- **VSCode/Cursor Extensions**: Managed via Nix home-manager
- **Browser Extensions**: Configured through policies and automated installation
- **Shell Extensions**: Zsh plugins and configurations in Nix
- **System Preferences**: All settings version-controlled
- **Web App Profiles**: Separate work/personal profiles with distinct settings
- **Keyboard Shortcuts**: Consistent across all applications
- **Themes**: Single source of truth for Tokyo Night across all apps

### Browser Strategy
- **LibreWolf**: Personal browsing with privacy-focused defaults
- **ungoogled-chromium**: Web app engine with separate work/personal profiles
- **Profile Isolation**: Complete separation of work and personal data
- **Extension Management**: Code-controlled extension installation and configuration

## Implementation Plan

### Phase 1: Core Keyboard Productivity (Week 1)
1. Add terminal dropdown functionality
2. Implement global search shortcuts
3. Enhance window switching
4. Add media control improvements
5. Create development workflow shortcuts

### Phase 2: Development Environment (Week 2)
1. Enhance Neovim configuration
2. Add VSCode productivity extensions
3. Install language development tools
4. Create build/test shortcuts
5. Add development servers

### Phase 3: Security & Profiles (Week 3)
1. Implement SSH agent auto-start
2. Add FIDO U2F support
3. Integrate password managers
4. Create work/personal profile separation
5. Implement automatic git config switching

### Phase 4: UI/UX Polish (Week 4)
1. Theme login and lock screens
2. Enhance notifications
3. Organize system tray
4. Add fuzzy finding improvements
5. Implement clipboard management

### Phase 5: Automation & Advanced Features (Ongoing)
1. Create backup automation
2. Add productivity scripts
3. Implement advanced window management
4. Add ecosystem integrations

## Specific Implementation Details

### Keyboard Shortcuts Enhancement
```nix
# Add to hyprland.nix bind section
"$mod, grave, exec, [floating] kitty --class=dropdown"  # Terminal dropdown
"$mod, slash, exec, rofi -show combi"  # Global search
"$mod, Tab, exec, rofi -show window"  # Window switcher
# Media controls
", XF86AudioPlay, exec, playerctl play-pause"
", XF86AudioNext, exec, playerctl next"
", XF86AudioPrev, exec, playerctl previous"
```

### Neovim Enhancement
- Add LSP support (nixd, gopls, pyright)
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- Essential plugins (vim-surround, commentary, etc.)

### Work Profile Implementation
- **Browser Profiles**: Separate ungoogled-chromium profiles for work/personal
- **Work Web Apps**: Outlook, Teams, Slack as PWAs in work profile
- **Personal Web Apps**: Gmail, Calendar, Linear, Notion, ChatGPT in personal profile
- **Directory-based Git Config**: Automatic switching based on ~/code/work vs ~/code/personal
- **Environment Variables**: Profile-specific settings and paths
- **Extension Management**: Work-specific extensions (company policies, etc.) vs personal privacy extensions

### Security Improvements
- SSH agent service configuration
- PAM U2F module for sudo
- Password manager desktop integration
- Hardware token support

## Success Metrics

### Productivity Gains
- **Shortcut Coverage**: 90% of daily tasks keyboard-accessible
- **Context Switching**: <2 seconds between tasks
- **Development Flow**: Seamless build/test/deploy cycles
- **Security**: Zero-password workflows where possible

### User Experience
- **Consistency**: Single theme across all applications
- **Responsiveness**: <100ms response to all shortcuts
- **Reliability**: 99.9% uptime for critical workflows
- **Maintainability**: Easy updates and customization

### Developer Experience
- **Setup Time**: <5 minutes for new development environments
- **Tool Discovery**: Intuitive access to all tools
- **Error Handling**: Clear feedback and recovery paths
- **Extensibility**: Easy addition of new tools/workflows

## Risks & Mitigations

### Complexity Creep
- **Risk**: Adding too many tools reduces minimal philosophy
- **Mitigation**: Strict package limits, regular cleanup reviews

### Performance Impact
- **Risk**: Too many background services slow system
- **Mitigation**: Performance monitoring, lazy loading

### Maintenance Burden
- **Risk**: Complex config becomes hard to maintain
- **Mitigation**: Modular design, documentation, automation

### Security Trade-offs
- **Risk**: Convenience features reduce security
- **Mitigation**: Defense in depth, regular security reviews

## Conclusion

This improvement plan maintains the minimal, web-first philosophy while significantly enhancing keyboard-driven productivity. The phased approach ensures steady progress without overwhelming the system. Focus on high-impact changes first, with polish and advanced features following core functionality.

The result will be a highly productive, secure, and maintainable developer environment that leverages NixOS's strengths for reproducible, keyboard-centric workflows.
