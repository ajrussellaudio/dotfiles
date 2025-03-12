# App aliases
alias k='clear'

alias ls="eza"
alias ll="eza -alh"

alias grep="rg"

TREE_OPTIONS="--tree --group-directories-first --ignore-glob=\"node_modules|.git\""
alias tree="eza $TREE_OPTIONS"
alias treea="eza --all $TREE_OPTIONS"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi \
--preview 'bat --plain --color=always --tabs=2 {}'"

alias f="fzf"

alias cat="bat"
alias catp="bat --plain"
alias catf="fd --hidden --type f --exclude .git | fzf --reverse --bind 'enter:become(bat {})'"

# alias nv='nvim $(fd --hidden --type f --exclude .git | fzf-tmux -p --reverse)'
alias nv="fd --hidden --type f --exclude .git | fzf --reverse --bind 'enter:become(nvim {})'"

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

# Give Copilot shell access
eval "$(gh copilot alias -- zsh)"
