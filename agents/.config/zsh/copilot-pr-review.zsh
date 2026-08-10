copilot-pr-review() {
  local pr_number="$1"

  if [[ -z "$pr_number" ]]; then
    echo "Usage: copilot-pr-review <pr-number>" >&2
    return 1
  fi

  # Validate the PR exists and fetch metadata
  local pr_json
  pr_json=$(gh pr view "$pr_number" --json headRefName,baseRefName 2>&1) || {
    echo "Error: could not fetch PR #${pr_number}: ${pr_json}" >&2
    return 1
  }

  local head_branch base_branch
  head_branch=$(echo "$pr_json" | jq -r '.headRefName')
  base_branch=$(echo "$pr_json" | jq -r '.baseRefName')

  local review_cmd="git pull origin ${head_branch} && claude -p \"/code-review-and-quality - Review all changes between HEAD and origin/${base_branch}.\" --permission-mode bypassPermissions"

  if type create-worktree &>/dev/null; then
    local win_name
    win_name=$(_worktree_name "$head_branch")

    create-worktree "$head_branch"

    # Keys buffer in the terminal input until the new shell is ready
    tmux send-keys -t ":${win_name}" "$review_cmd" Enter
  else
    gh pr checkout "$pr_number"
    eval "$review_cmd"
  fi
}

alias cpr=copilot-pr-review
