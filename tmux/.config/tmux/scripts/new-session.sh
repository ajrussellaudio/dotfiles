#!/bin/zsh
tput setaf 2
echo -n "   "
tput sgr0

# bash
# read -p "New session name: " NAME

# zsh
read "NAME?New session name: "

tmux new-session -d -s "$NAME"
tmux switch-client -t "$NAME"

