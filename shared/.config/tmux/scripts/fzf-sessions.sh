#!/bin/zsh

tmux list-sessions -F "#S" \
    | grep -v $(tmux display-message -p "#S") \
    | fzf \
        --tmux 80% \
        --no-multi \
        --reverse \
        --preview="tmux capture-pane -pe -t {} | bat -p" \
        --preview-window=right,80% \
        --preview-border=line \
        --ghost="Session name" \
        --header="Available Sessions:" \
        --border \
        --border=rounded \
        --border-label=" $1 " \
        --color=label:italic:black \
