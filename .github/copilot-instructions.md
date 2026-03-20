# Copilot Instructions

## Key Conventions

**New shell functionality:** create `zsh/.config/zsh/<feature>.zsh` — it will be sourced automatically by `.zshrc`.

**New tools:** add to `mise/.config/mise/config.toml` if possible; fall back to `do_install "tool-name"` in `install_all.sh`.

**Theme:** Catppuccin Mocha is used across all tools. Apply it when configuring any new tool that supports it.

**Neovim:** `lazy-lock.json` is tracked in git — do not gitignore it.

## Pull Request Reviews

When creating a PR, always include the following at the end of the PR description to encourage a thorough single-pass review:

```
---

@copilot Please provide a **complete and exhaustive review in a single pass** — include all issues, edge cases, and suggestions at once rather than across multiple rounds.
```

After every `git push` on a PR branch, re-request a review from the Copilot reviewer bot:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/requested_reviewers \
  --method POST \
  --field 'reviewers[]=copilot-pull-request-reviewer[bot]'
```

Note: use the login name `copilot-pull-request-reviewer[bot]` — do not hard-code a numeric user ID as it may differ between repositories.

