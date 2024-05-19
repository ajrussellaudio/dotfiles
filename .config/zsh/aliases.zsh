# App aliases
alias k='clear'

alias ls="eza"
alias ll="eza -alh"

TREE_OPTIONS="--tree --group-directories-first --ignore-glob=\"node_modules|.git\""
alias tree="eza $TREE_OPTIONS"
alias treea="eza --all $TREE_OPTIONS"

if command -v bat > /dev/null; then
  alias cat="bat"
elif command -v batcat > /dev/null; then
  alias cat="batcat"
fi

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
