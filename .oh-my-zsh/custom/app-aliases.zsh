alias bbd="rm -f ./Brewfile* && brew bundle dump --taps --brews --casks --mas" 

alias ls="eza"
alias ll="eza -alh"
alias tree="eza -TI node_modules"

if command -v bat > /dev/null; then
  alias cat="bat"
elif command -v batcat > /dev/null; then
  alias cat="batcat"
fi
