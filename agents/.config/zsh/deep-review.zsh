deep-review() {
  local pr_number="$1"

  if [[ -z "$pr_number" ]]; then
    echo "Usage: deep-review <pr-number>" >&2
    return 1
  fi

  # Validate the PR exists and fetch metadata
  local pr_json
  pr_json=$(gh pr view "$pr_number" --json headRefName,baseRefName,url 2>&1) || {
    echo "Error: could not fetch PR #${pr_number}: ${pr_json}" >&2
    return 1
  }

  local head_branch base_branch pr_url
  head_branch=$(echo "$pr_json" | jq -r '.headRefName')
  base_branch=$(echo "$pr_json" | jq -r '.baseRefName')
  pr_url=$(echo "$pr_json" | jq -r '.url')

  # create-worktree already fetched and placed the worktree at origin/<branch>,
  # and gh pr checkout fetches too — so no pull is needed here.
  local review_cmd="claude \"/deep-review - Review PR #${pr_number}: ${pr_url}. Read the PR description and any linked issues first to establish intent, then review the changes between HEAD and origin/${base_branch}.\""

  if type create-worktree &>/dev/null; then
    local win_name="review-PR-${pr_number}"

    create-worktree "$head_branch" "$win_name"

    # Keys buffer in the terminal input until the new shell is ready. Once
    # Claude exits, tear down the worktree and its window, as cwrm does.
    tmux send-keys -t ":${win_name}" "${review_cmd}; remove-current-worktree" Enter
  else
    gh pr checkout "$pr_number"
    eval "$review_cmd"
  fi
}

alias dpr=deep-review
