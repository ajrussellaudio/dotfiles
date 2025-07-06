# Confused?
# https://www.youtube.com/watch?v=ud7YxC33Z3w&t=5s
# https://github.com/dreamsofautonomy/zensh/blob/main/.zshrc

# Integrate Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Plugin manager replacement
ZSH_PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

clone_plugin() {
    local repo_url="$1"
    local plugin_name="$(basename "$repo_url")"
    local plugin_path="$ZSH_PLUGINS_DIR/$plugin_name"
    [ -d "$plugin_path" ] || git clone --depth 1 "$repo_url" "$plugin_path"
}

clone_plugin "https://github.com/zdharma-continuum/fast-syntax-highlighting"
clone_plugin "https://github.com/zsh-users/zsh-autosuggestions"
clone_plugin "https://github.com/zsh-users/zsh-completions"
clone_plugin "https://github.com/Aloxaf/fzf-tab"
clone_plugin "https://github.com/ohmyzsh/ohmyzsh"

# Initialize completions so plugins can use them
fpath=($ZSH_PLUGINS_DIR/zsh-completions/src $fpath)
autoload -U compinit && compinit

# Source plugins
source "$ZSH_PLUGINS_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey '^n' autosuggest-accept

source "$ZSH_PLUGINS_DIR/fzf-tab/fzf-tab.plugin.zsh"

source "$ZSH_PLUGINS_DIR/ohmyzsh/lib/git.zsh"
source "$ZSH_PLUGINS_DIR/ohmyzsh/plugins/git/git.plugin.zsh"
unalias grv

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
