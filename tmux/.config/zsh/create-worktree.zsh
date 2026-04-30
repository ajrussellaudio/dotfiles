create-worktree() {
  local branch="$1" dir="../$(basename "$PWD")-${1//\//-}"
  git worktree add "$dir" -b "$branch" 2>/dev/null || git worktree add "$dir" "$branch"
  tmux new-window -n "$branch" -c "$dir" 
}

remove-current-worktree() {
 local dir="$PWD" common main win
 common=$(git rev-parse --git-common-dir 2>/dev/null) || { echo "not in a git worktree" >&2; return 1; }
 main=$(cd "$(dirname "$common")" && pwd)
 [ "$dir" = "$main" ] && { echo "refusing to remove main worktree" >&2; return 1; }

 win=$(tmux display-message -p '#{window_id}' 2>/dev/null)

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
