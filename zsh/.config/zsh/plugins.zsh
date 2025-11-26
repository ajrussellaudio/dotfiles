# ~/.config/zsh/plugins.zsh

# Define the directory where plugins will be stored
ZSH_PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

# List of plugins to manage
declare -a plugins=(
    "https://github.com/zdharma-continuum/fast-syntax-highlighting"
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-completions"
    "https://github.com/Aloxaf/fzf-tab"
    "https://github.com/ohmyzsh/ohmyzsh"
)

# --- Plugin Management ---

# Function to update all plugins. Can be run on-demand.
zsh_update_plugins() {
    for repo_url in "${plugins[@]}"; do
        local plugin_name
        plugin_name=$(basename "$repo_url")
        local plugin_path="$ZSH_PLUGINS_DIR/$plugin_name"

        if [ -d "$plugin_path" ]; then
            echo "Updating $plugin_name..."
            (cd "$plugin_path" && git pull)
        else
            echo "$plugin_name not found. Cloning..."
            git clone --depth 1 "$repo_url" "$plugin_path"
        fi
    done
}

# Function to install plugins if they are missing. Runs on shell startup.
install_plugins_if_missing() {
    for repo_url in "${plugins[@]}"; do
        local plugin_name=$(basename "$repo_url")
        local plugin_path="$ZSH_PLUGINS_DIR/$plugin_name"

        if [ ! -d "$plugin_path" ]; then
            git clone --depth 1 "$repo_url" "$plugin_path"
        fi
    done
}

# Ensure plugins are installed on startup
install_plugins_if_missing

# --- Completion Initialization ---
# Add zsh-completions to fpath and initialize compinit for faster startup
# See: https://github.com/zsh-users/zsh-completions#usage
fpath=("$ZSH_PLUGINS_DIR/zsh-completions/src" $fpath)

# Initialize the completion system
# The -C option makes compinit check if .zcompdump needs to be regenerated
autoload -U compinit
if [ -n "$ZSH_PLUGINS_DIR/zsh-completions/src/_git" ]; then
  compinit -C
else
  compinit
fi

# --- Source Plugins and Configure ---

# fast-syntax-highlighting
source "$ZSH_PLUGINS_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# zsh-autosuggestions
source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey '^n' autosuggest-accept # Accept suggestion with Ctrl+N

# fzf-tab
source "$ZSH_PLUGINS_DIR/fzf-tab/fzf-tab.plugin.zsh"

# Oh My Zsh git plugin
source "$ZSH_PLUGINS_DIR/ohmyzsh/lib/git.zsh"
source "$ZSH_PLUGINS_DIR/ohmyzsh/plugins/git/git.plugin.zsh"
unalias grv # Remove alias that might conflict

# --- Completion Styling ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)EZA_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --oneline --all --color=always $realpath'
zstyle ':fzf-tab:complete:rm:*' fzf-preview 'if [ -d $realpath ]; \
        then eza --oneline --all --icons --color=always $realpath; \
        elif [ -f $realpath ]; \
        then bat --plain --color=always --tabs=2 $realpath; \
        else echo "Preview not available."; \
        fi'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'if [ -d $realpath ]; \
        then eza --oneline --all --icons --color=always $realpath; \
        elif [ -f $realpath ]; \
        then bat --plain --color=always --tabs=2 $realpath; \
        else echo "Preview not available."; \
        fi'
