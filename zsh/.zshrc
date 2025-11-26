# --- Environment and Path ---
# Set XDG base directories for config files
export XDG_CONFIG_HOME="$HOME/.config"

# Set Neovim as the default editor
export EDITOR="nvim"

# Add Homebrew to the path if it exists
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add Rancher Desktop to the path if it exists
if [ -d "$HOME/.rd" ]; then
  export PATH="$HOME/.rd/bin:$PATH"
fi

# Add my scripts to the path if any exist
if [ -d "$HOME/.bin" ]; then
  export PATH="$HOME/.bin:$PATH"
fi

# --- Shell Behavior and History ---
# History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
  hist_save_no_dups hist_ignore_dups hist_find_no_dups

# --- Plugins and Completions ---
# Load plugins and initialize the completion system
source "$HOME/.config/zsh/plugins.zsh"

# --- Tools and Integrations ---

# --- UI and Prompt ---

# Oh My Posh prompt
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"
fi

# --- Personalizations ---
# Load personal scripts and aliases
for script in ~/.config/zsh/*.zsh; do
  if [[ -f "$script" && "$(basename "$script")" != "plugins.zsh" ]]; then
    source "$script"
  fi
done
