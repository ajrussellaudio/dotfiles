# App aliases
alias k='clear'

alias ls="eza"
alias ll="eza -alh"

alias grep="rg"

TREE_OPTIONS="--tree --group-directories-first --ignore-glob=\"node_modules|.git\""
alias tree="eza $TREE_OPTIONS"
alias treea="eza --all $TREE_OPTIONS"

export FZF_DEFAULT_OPTS="--preview 'bat --plain --color=always --tabs=2 {}'"
alias f="fzf"

alias cat="bat"
alias catp="bat --plain"
alias catf='bat $(fd --hidden --type f --exclude .git | fzf-tmux -p --reverse)'

alias nv='nvim $(fd --hidden --type f --exclude .git | fzf-tmux -p --reverse)'

# Folder aliases
create_or_cd () {
  [ ! -d $1 ] && mkdir $1
  cd $1
}

work () { create_or_cd ~/Documents/working }
learn () { create_or_cd ~/Documents/learning }
play () { create_or_cd ~/Documents/playground }
oss () { create_or_cd ~/Documents/open-source }
cfg () { create_or_cd ~/dotfiles } 

set -o AUTO_CD
alias ...="../.."
alias ....="../../.."
alias .....="../../../.."
alias ......="../../../../.."
alias .......="../../../../../.."
alias ........="../../../../../../.."
alias .........="../../../../../../../.."
