create-worktree() {
  local branch="$1" dir="../$(basename "$PWD")-${1//\//-}"
  git worktree add "$dir" -b "$branch" 2>/dev/null || git worktree add "$dir" "$branch"
  tmux new-window -n "$branch" -c "$dir"
}

_worktree_descendant_pids() {
  local parent="$1" child

  while IFS= read -r child; do
    [[ -z "$child" ]] && continue
    print -r -- "$child"
    _worktree_descendant_pids "$child"
  done < <(pgrep -P "$parent" 2>/dev/null)
}

_worktree_window_child_pids() {
  local win="$1" pane_pid

  tmux list-panes -t "$win" -F '#{pane_pid}' 2>/dev/null | while IFS= read -r pane_pid; do
    [[ -z "$pane_pid" ]] && continue
    _worktree_descendant_pids "$pane_pid"
  done
}

remove-current-worktree() {
  local dir="$PWD" common main win
  common=$(git rev-parse --git-common-dir 2>/dev/null) || { echo "not in a git worktree" >&2; return 1; }
  main=$(cd "$(dirname "$common")" && pwd)
  [ "$dir" = "$main" ] && { echo "refusing to remove main worktree" >&2; return 1; }

  win=$(tmux display-message -p '#{window_id}' 2>/dev/null)

  local -a child_pids
  if [[ -n "$win" ]]; then
    child_pids=(${(f)"$(_worktree_window_child_pids "$win")"})
    if (( ${#child_pids[@]} > 0 )); then
      ps -o pid,ppid,comm -p "${(j:,:)child_pids}"
      read -q "REPLY?Window has ${#child_pids[@]} child process(es). Kill anyway? [y/N] " || return 1
      echo
    fi
  fi

  cd "$main" || return 1
  if ! git worktree remove "$dir" 2>/dev/null; then
    read -q "REPLY?Worktree dirty/locked. Force remove? [y/N] " || { cd "$dir"; return 1; }
    echo
    git worktree remove --force "$dir" || { cd "$dir"; return 1; }
  fi

  [ -n "$win" ] && tmux kill-window -t "$win"
}

alias cw=create-worktree
alias cwrm=remove-current-worktree
