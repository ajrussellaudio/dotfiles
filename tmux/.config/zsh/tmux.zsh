# Add Tmuxifier to the path if it is installed
if [ -d "$HOME/.config/tmux/plugins/tmuxifier" ]; then
    export PATH="$HOME/.config/tmux/plugins/tmuxifier/bin:$PATH"
    eval "$(tmuxifier init -)"
    export TMUXIFIER_LAYOUT_PATH="$HOME/.config/tmux/layouts"
fi


