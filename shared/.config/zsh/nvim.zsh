# alias nv='nvim $(fd --hidden --type f --exclude .git | fzf-tmux -p --reverse)'
alias nv="fd --hidden --type f --exclude .git | fzf --reverse | xargs nvim"

