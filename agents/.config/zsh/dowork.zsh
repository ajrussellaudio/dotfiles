_dowork_branch_re='^(feat|fix|hotfix|chore|release|docs|test|refactor|dev|spike)/[A-Z][A-Z0-9]*-[0-9]+(-[A-Za-z0-9]+)+$'

# Ask a cheap model to read the ticket and name the branch per twinkl-core:git.
_dowork_branch_name() {
  local ticket="$1" branch

  # The prompt goes before --allowedTools, which would otherwise swallow it as
  # another tool name.
  branch=$(claude -p "Read Jira ticket ${ticket} and reply with only a git branch name for it, no other text.
Format: <type>/${ticket}-<description>
- type: one of feat, fix, hotfix, chore, release, docs, test, refactor, dev, spike — pick the one that fits the work.
- description: 2-5 lowercase hyphen-separated alphanumeric words summarising the ticket title.
Example: feat/${ticket}-add-login" \
    --model haiku \
    --allowedTools mcp__claude_ai_Atlassian_MCP__getAccessibleAtlassianResources mcp__claude_ai_Atlassian_MCP__getJiraIssue) || return 1

  # keep the last non-empty line, in case the model added any preamble
  branch=$(print -r -- "$branch" | sed '/^[[:space:]]*$/d' | tail -n 1 | tr -d '[:space:]`')

  if [[ ! "$branch" =~ $_dowork_branch_re || "$branch" != */${ticket}-* ]]; then
    echo "generated branch name doesn't match the convention: '$branch'" >&2
    return 1
  fi
  print -r -- "$branch"
}

dowork() {
  local ticket="$1" branch

  if [[ ! "$ticket" =~ '^[A-Z][A-Z0-9]*-[0-9]+$' ]]; then
    echo "Usage: dowork <ticket-key>  (e.g. dowork CAPP-1234)" >&2
    return 1
  fi
  [[ -z "$TMUX" ]] && { echo "dowork needs to run inside tmux" >&2; return 1 }

  echo "Naming branch for ${ticket}…"
  branch=$(_dowork_branch_name "$ticket") || return 1
  echo "Branch: ${branch}"

  create-worktree "$branch" "$ticket" || return 1

  # Keys buffer in the terminal input until pnpm install finishes and the new
  # shell is ready, so Claude starts only after setup. Once Claude exits, tear
  # down the worktree and its window, as cwrm does.
  tmux send-keys -t ":${ticket}" "claude \"/implement ${ticket}\"; remove-current-worktree" Enter
}

alias dw=dowork
