# Open buffer line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line
