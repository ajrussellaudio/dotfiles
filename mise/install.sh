#!/usr/bin/env bash
source "$HOME/dotfiles/_install/utils.sh"

# Install mise and stow its config, then install the tools it manages.
do_install "mise"
mise install
