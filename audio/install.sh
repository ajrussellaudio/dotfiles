#!/usr/bin/env bash
#
# Audio setup. Not run by install_all.sh; run directly: ./audio/install.sh
source "$HOME/dotfiles/_install/utils.sh"

brew_install "bitwig-studio"
brew_install "dfu-util"
brew_install "ffmpeg"
brew_install "rubberband"
brew_install "sox"
