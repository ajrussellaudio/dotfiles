#!/usr/bin/env bash
source "$HOME/dotfiles/_install/utils.sh"

# Stow skills (~/.agents/skills) plus Copilot and OpenCode config.
stow_pkg "agents"

# Copilot CLI
brew_install "copilot-cli"

# Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# OpenCode
curl -fsSL https://opencode.ai/install | bash
