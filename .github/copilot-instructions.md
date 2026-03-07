# Copilot Instructions

## Repository Overview

GNU Stow-based personal dotfiles supporting macOS (primary) and Linux. Each top-level directory is an independent Stow package that symlinks into `~`.

## How Stow Works Here

Package directories mirror the home directory structure:
- `zsh/.zshrc` → `~/.zshrc`
- `neovim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`

Stowing/unstowing is done via helpers in `_install/utils.sh`:
```bash
source _install/utils.sh
_safely_stow add <package>       # Create symlinks
_safely_stow remove <package>    # Remove symlinks
do_install <package>             # brew/apt install + stow
```

Or directly: `stow -d ~/dotfiles -v <package>`

## Installation

```bash
./install_all.sh       # Full macOS setup
./install_audio.sh     # Audio production tools
./install_work.sh      # Work-specific tools

mise install           # Install all language runtimes and CLI tools after stowing mise/
```

## Package Conventions

- **XDG-compliant tools:** `<package>/.config/<tool>/` (preferred)
- **Legacy dotfiles:** Place at package root, e.g., `zsh/.zshrc`
- **Package name = tool name** (lowercase): `neovim/`, `tmux/`, `ghostty/`
- **Adding a new tool:**
  1. Add to `mise/.config/mise/config.toml` if it's a runtime or `mise`-managed CLI
  2. Otherwise add `do_install "tool-name"` in `install_all.sh`
  3. Create `<tool>/.config/<tool>/` with config files
  4. Verify with `stow -v <tool>`

## Shell (Zsh)

Config is auto-composed: `zsh/.zshrc` sources every `~/.config/zsh/*.zsh` file except `plugins.zsh`.

**Add new shell functionality:** create `zsh/.config/zsh/<feature>.zsh` — it will be sourced automatically.

**Plugin management** (`plugins.zsh`): No plugin manager. Repos are git-cloned to `~/.local/share/zsh/plugins/` and sourced directly. Update with `zsh_update_plugins`.

Current plugins: `fast-syntax-highlighting`, `zsh-autosuggestions`, `zsh-completions`, `fzf-tab`, `ohmyzsh` (git plugin only).

**Key aliases/functions defined in `zsh/.config/zsh/`:**
- `nv` — fuzzy file open in Neovim (via `fd` + `fzf`)
- `y` — Yazi file manager (changes CWD on exit)
- `k` — clear screen
- `cht` — curl-based cht.sh lookup
- Global aliases: `NE` (silence stderr), `NO` (silence stdout), `J` (pipe to jq), `C` (copy to clipboard)
- Suffix aliases: `.json` → jless/bat, `.md` → glow/bat, etc.
- `zcp`/`zln` — `zmv`-based pattern copy/link

## Neovim

Lua-based config using `lazy.nvim`. Plugin specs live in `lua/plugins/` (one file per plugin/feature). Mini.nvim modules are in `lua/plugins/mini/`.

**Adding a plugin:** create a new spec file in `lua/plugins/`. Changes take effect on next `:Lazy sync`.

**LSP/formatting/linting** managed via Mason. Ensure-installed list is in `lua/plugins/lsp.lua`. Formatter config is in `lua/plugins/conform.lua`.

Key tool decisions:
- Completion: `blink.nvim`
- Fuzzy finding: `fzf-lua` (not Telescope)
- Colorscheme: Catppuccin mocha (used everywhere — Neovim, tmux, ghostty, oh-my-posh, bat, git-delta)
- File browser: `mini.files`
- Leader key: `Space`

The `lazy-lock.json` is tracked in git. Run `:Lazy restore` to pin to locked versions.

## Tmux

Config entry point: `tmux/.config/tmux/tmux.conf`. OS overrides in `tmux.os.conf`. Popup configs in `popups/` are auto-loaded. Session layouts in `layouts/`.

- Prefix: `Ctrl+Space`
- Plugins via TPM: `tmuxifier` (layouts), `vim-tmux-navigator`, `tmux-fuzzback`, `tmux-fzf-url`, `tmux-spotify`
- Reload config: `<prefix> r`
- Pane/window navigation shared with Neovim via `vim-tmux-navigator`

## Runtime Management (Mise)

All language runtimes and many CLI tools are declared in `mise/.config/mise/config.toml`. Prefer adding tools here over Homebrew when possible.

Managed runtimes: Node (LTS), Python, Go, Rust, Zig  
Managed CLIs: `aws-cli`, `aws-vault`, `terraform`, `terragrunt`, `pnpm`, `uv`, `yarn`, `gemini-cli`, `claude-code`, `@github/copilot`

`mise` respects `.nvmrc` and `.python-version` files for Node and Python (configured via `idiomatic_version_file_enable_tools`).

## Consistent Theme

**Catppuccin Mocha** is used across all tools: Neovim, tmux (`tmux.catppuccin.conf`), Ghostty, Oh My Posh, bat, and git-delta. When configuring new tools, apply Catppuccin Mocha theme if available.

## Git Config

- Signing: SSH key `~/.ssh/id_ed25519.pub`
- Diff pager: `delta` with Catppuccin theme
- Conflict style: `diff3`
- Default: rebase on pull

## Custom Scripts

`scripts/.bin/` is on `$PATH`. Key scripts:
- `mksh` — scaffold a new shell script
- `mkts` — scaffold a TypeScript project
- `mkfn` — scaffold a TypeScript function (with optional test file)
- `copy` — cross-platform clipboard copy (used by shell widgets and aliases)
