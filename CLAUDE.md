# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using GNU Stow for package management. Configuration is organized into discrete packages (directories) that can be independently installed via `stow`. The repository supports both macOS and Linux.

## Package Structure

Packages are organized as top-level directories, each containing either:
- A `.config` subdirectory for XDG-compliant configurations
- Dotfiles at the package root (like `.zshrc`)

When stowed, files are symlinked from `~/dotfiles/<package>` to `~` (so `zsh/.zshrc` becomes `~/.zshrc`).

Key architectural patterns:
- Platform-specific packages: `mac/` and `linux/` (future)
- Tool-specific packages (one per tool) for isolated config management

## Installation and Setup

```bash
# Install all packages and dependencies (macOS)
./install_all.sh

# Install a specific package
source _install/utils.sh
do_install <package_name>  # Installs via brew/apt and stows config

# Manually stow a package
stow -d ~/dotfiles -v <package_name>

# Remove a stowed package
stow -d ~/dotfiles -vD <package_name>

# Update mise tools
mise install
```

### Install Script Architecture

The installation system is in `_install/utils.sh`:
- `do_install <package>`: Installs via package manager and stows the config
- `_use_package_manager {add|remove} <package>`: Wraps brew/apt commands
- `_safely_stow {add|remove} <package>`: Creates symlinks via stow

## Development Tools

### Runtime Management (mise)

All language runtimes and CLI tools are managed via mise (configured in `mise/.config/mise/config.toml`):
- Runtimes: Node (LTS), Python, Go, Rust
- AI tools: gemini-cli, claude-code, @github/copilot, mcp-hub
- AWS tools: aws-cli, aws-vault, terraform, terragrunt
- Package managers: pnpm, uv, yarn, zig

When adding new tools, prefer mise over brew where possible.

### Shell (Zsh)

Shell config is split between:
- `zsh/.zshrc`: Main entry point, loads plugins and sources `~/.config/zsh/*.zsh`
- `zsh/.config/zsh/plugins.zsh`: Plugin management (auto-installs from GitHub)
- `zsh/.config/zsh/*.zsh`: Individual feature modules (aliases, functions, integrations)

Plugins are managed without a plugin manager - repos are cloned to `~/.local/share/zsh/plugins/` and sourced directly. Update with `zsh_update_plugins`.

### Neovim

Neovim config uses lazy.nvim for plugin management. Architecture:
- `init.lua`: Entry point, loads core config and lazy.nvim
- `lua/config/`: Core settings (options, keymaps, autocmd, diagnostics)
- `lua/plugins/`: Plugin specs (one file per plugin or feature area)
- `lua/plugins/mini/`: Mini.nvim module plugins
- `lua/lsp/`: LSP-specific configuration

Plugins are auto-installed on first launch. Lock file is tracked in `lazy-lock.json`.

### Tmux

Tmux config follows a modular structure:
- `tmux/.config/tmux/tmux.conf`: Main config
- `tmux/.config/tmux/popups/*.conf`: Popup window configs (auto-loaded)
- `tmux/.config/tmux/layouts/`: Tmuxifier layout definitions
- `tmux/.config/tmux/tmux.os.conf`: OS-specific overrides

Plugins managed via TPM (Tmux Plugin Manager). Prefix key is `Ctrl+Space`.

## Common Patterns

### Adding a New Tool

1. Install via mise if possible (add to `mise/.config/mise/config.toml`)
2. Otherwise, add to `install_all.sh` via `do_install "tool-name"`
3. Create package directory: `mkdir -p <tool>/.config/<tool>`
4. Add config files to the package
5. Test with `stow -v <tool>`

### Adding Shell Functionality

Create a new file in `zsh/.config/zsh/<feature>.zsh` - it will be auto-sourced by `.zshrc`.

### Modifying Neovim Plugins

Edit the corresponding file in `lua/plugins/`. Changes take effect on next `:Lazy sync`.

## Testing Changes

After modifying configs:
- Shell: `source ~/.zshrc` or restart shell
- Tmux: `Ctrl+Space r` to reload config
- Neovim: Restart nvim or `:source $MYVIMRC` for core config changes

When testing stow operations, always use the `-v` flag to see what would be linked.
