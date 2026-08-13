#!/usr/bin/env bash
source "$HOME/dotfiles/_install/utils.sh"

# Stow skills (~/.claude/skills), OpenCode config, and the claude/opencode
# shell completions.
stow_pkg "agents"
