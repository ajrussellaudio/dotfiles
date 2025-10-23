session_root "~/dotfiles"

new_window_titled () {
  window_root "$session_root/$1"
  new_window $1
}

if initialize_session "dotfiles"; then

    new_window "root"
    split_h 20
    run_cmd "nvim" 1
    select_pane 1

    window_root "$session_root/shared/.config/nvim"
    new_window "nvim"
    run_cmd "nvim"

    window_root "$session_root/shared/.config/tmux"
    new_window "tmux"
    run_cmd "nvim"

    select_window 1

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
