#!/usr/bin/env bash
source "$HOME/dotfiles/_install/utils.sh"

# zsh plus completions (completions has no config to stow)
do_install "zsh"
brew_install "zsh-completions"
