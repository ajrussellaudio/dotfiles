# Confused?
# https://www.youtube.com/watch?v=ud7YxC33Z3w&t=5s
# https://github.com/dreamsofautonomy/zensh/blob/main/.zshrc

# Integrate Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
  zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start; bindkey '^n' autosuggest-accept" \
  zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab

# Add in snippets
zinit wait lucid for \
  OMZL::git.zsh \
  atload"unalias grv" \
  OMZP::git

# History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
  hist_save_no_dups hist_ignore_dups hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)EZA_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"

# Set Neovim as editor
export EDITOR="nvim"

# Set ~/.config as config directory for most stuff
export XDG_CONFIG_HOME="$HOME/.config"

# jdx/mise - dev tools
eval "$($(which mise) activate zsh)"

# Personal preferences
for script in ~/.config/zsh/*.zsh; do
  if [ -f "$script" ]; then
    source "$script"
  fi
done

# Rancher Desktop for work
if [ -d "$HOME/.rd" ]; then
  export PATH="$HOME/.rd/bin:$PATH"
fi

# Tmuxifier if installed
if [ -d "$HOME/.config/tmux/plugins/tmuxifier" ]; then
    export PATH="$HOME/.config/tmux/plugins/tmuxifier/bin:$PATH"
    eval "$(tmuxifier init -)"
    export TMUXIFIER_LAYOUT_PATH="$HOME/.config/tmux/layouts"
fi

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"
fi
