alias bbd="rm -f ./Brewfile* && brew bundle dump --taps --brews --casks --mas" 

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
