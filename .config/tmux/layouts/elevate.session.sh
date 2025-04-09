# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Documents/working/elevate-app/apps/elevatesupply.co.uk/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "elevate"; then

    # Create a new window inline within session layout definition.
    new_window "editor"
    run_cmd "nvim"
    split_h 20

    new_window "run"
    run_cmd 'yarn install && mprocs "yarn dev" "yarn test" "yarn storybook --no-open" "yarn lint" "yarn typecheck --watch"'
    split_h 20

    select_window 1
    select_pane 1

    # Load a defined window layout.
    #load_window "example"

    # Select the default active window on session creation.
    #select_window 1

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
