#!/usr/bin/env bash
source "$HOME/dotfiles/_install/utils.sh"

# Install stow itself and stow ~/.stow-global-ignore.
#
# Runs first (see PRIORITY in install_all.sh) so the ignore rules apply to
# every package stowed afterwards.
do_install "stow"
