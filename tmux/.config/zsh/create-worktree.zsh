_worktree_name() {
  local name="$1"

  [[ "$name" == */* ]] && name="${name#*/}"
  print -r -- "${name//\//-}"
}

# The local branch already exists, so the worktree checks out whatever state it
# was left in — which may be behind origin, ahead of it (unpushed commits), or
# diverged. Policy: fast-forward when nothing local is at stake, ask before
# discarding unpushed commits. Called with the worktree already created and
# checked out.
_worktree_sync_existing_branch() {
  local dir="$1" branch="$2" behind ahead REPLY

  git -C "$dir" branch --set-upstream-to="origin/$branch" "$branch" >/dev/null || return 1

  # commits on origin/$branch not in $branch, and vice versa
  read -r behind ahead <<<"$(git -C "$dir" rev-list --left-right --count "origin/$branch...$branch")"
  (( behind == 0 && ahead == 0 )) && return 0

  if (( ahead == 0 )); then
    git -C "$dir" merge --ff-only "origin/$branch" || return 1
    return 0
  fi

  echo "$branch has $ahead commit(s) not on origin/$branch:" >&2
  git -C "$dir" log --oneline "origin/$branch..$branch" >&2
  if ! read -q "REPLY?Discard them and match origin/$branch? [y/N] "; then
    echo
    echo "keeping local commits — worktree does NOT match origin/$branch" >&2
    return 0
  fi
  echo

  git -C "$dir" reset --hard "origin/$branch"
}

create-worktree() {
  local branch="$1" name dir
  [[ -z "$branch" ]] && { echo "usage: create-worktree <branch>" >&2; return 1 }
  name="$(_worktree_name "$branch")"
  dir="../$(basename "$PWD")-$name"

  local trust_cmd=""
  if mise trust --show 2>/dev/null | grep -q ': trusted$'; then
    trust_cmd="mise trust;"
  fi

  # refs are shared across worktrees, so one fetch here freshens origin/* for all
  git fetch --prune origin || return 1

  if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    # new work: branch off the current HEAD, nothing to sync
    git worktree add -b "$branch" "$dir" || return 1
  elif git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$dir" "$branch" || return 1
    _worktree_sync_existing_branch "$dir" "$branch" || return 1
  else
    # start at the remote commit and track it — no pull needed
    git worktree add --track -b "$branch" "$dir" "origin/$branch" || return 1
  fi

  local setup_cmd=""
  [[ -f "$dir/package.json" ]] && setup_cmd+='pnpm install;'

  tmux new-window -n "$name" -c "$dir" "${trust_cmd} ${setup_cmd} exec $SHELL -i"
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
