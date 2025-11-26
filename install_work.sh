#!/usr/bin/env bash

source "$HOME/dotfiles/_install/utils.sh"

_safely_stow add work

do_install "bruno"
do_install "elgato-control-center"
do_install "elgato-stream-deck"
