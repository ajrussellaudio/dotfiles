#!/usr/bin/env bash
source "$HOME/dotfiles/_install/utils.sh"

# Stow Claude skills (~/.claude/skills) plus the claude CLI shell completions.
stow_pkg "agents"
