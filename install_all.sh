#!/usr/bin/env bash

# Determine the directory where this script resides
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_SH="$DOTFILES_DIR/_install/utils.sh"
if [[ ! -f "$UTILS_SH" ]]; then
  echo "Error: utils.sh not found at $UTILS_SH"
  exit 1
fi
source "$UTILS_SH"

# Stuff to install first
do_install "ghostty"
do_install "zsh"
do_install "zsh-completions"
do_install "tmux"
do_install "neovim"
do_install "mise"
mise install

_safely_stow add scripts

# Stuff with config
do_install "bat"
do_install "btop"
do_install "eza"
do_install "fzf"
do_install "gh"
do_install "git-delta"
do_install "glow"
do_install "lazydocker"
do_install "lazygit"
do_install "mprocs"
do_install "oh-my-posh"
do_install "ripgrep"
do_install "stormy"

# Stuff with no config
do_install "1password"
do_install "1password-cli@beta"
do_install "ast-grep"
do_install "as-tree"
do_install "coreutils"
do_install "fastfetch"
do_install "fd"
do_install "flac"
do_install "jq"
do_install "obsidian"
do_install "spotify"
do_install "tldr"
do_install "vivaldi"

# Fonts
do_install "font-commit-mono-nerd-font"
do_install "font-sauce-code-pro-nerd-font"
do_install "font-victor-mono-nerd-font"
