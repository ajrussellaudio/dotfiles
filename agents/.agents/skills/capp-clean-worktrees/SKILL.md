---
name: capp-clean-worktrees
description: Tidy up CaPP git worktrees whose PRs are merged or closed without merging. Scans for directories matching the `<repo>_<TICKET-ID>` worktree convention (e.g. `twinkl-sanity-cms_CAPP-1234`), looks up each worktree's PR via `gh`, classifies by state, flags closed-unmerged PRs, and removes worktrees only after explicit user confirmation. Use when the user asks to clean up worktrees, prune CAPP worktrees, or tidy `~/Development`.
---

# CaPP Clean Worktrees

Identify CaPP worktrees whose work is finished (PR merged) or abandoned (PR closed without merging) and remove them safely. Never delete without confirmation.

## Worktree convention

Worktrees follow the `capp-do-work` convention:

- Path: `<repo-path>_<TICKET-ID>` — e.g. `~/Development/twinkl-sanity-cms_CAPP-1234`
- TICKET-ID is the **parent** Jira ticket, format `<UPPERCASE>-<DIGITS>` (e.g. `CAPP-1234`, `WEB-987`)
- Each worktree has a feature branch like `feat/CAPP-1234-add-seo-tags`

## Workflow

### 1. Choose search root

1. List directories in the **current working directory** (`pwd`).
2. If any contain a `.git` file or directory (i.e. there are git repos / worktrees in cwd), use cwd as the search root.
3. Otherwise fall back to `~/Development`.
4. State the chosen root to the user before scanning.

### 2. Discover candidate worktrees

Find directories matching the worktree pattern:

```sh
find <search-root> -maxdepth 2 -type d -name '*_[A-Z][A-Z]*-[0-9]*'
```

For each candidate:

- Confirm it is a git worktree: `git -C <path> rev-parse --is-inside-work-tree` returns `true`, and `git -C <path> rev-parse --git-common-dir` differs from `<path>/.git` (i.e. it is a linked worktree, not the main repo).
- Skip anything that is a regular clone or not a git directory.

### 3. Resolve PR state per worktree

For each confirmed worktree:

1. Get the branch: `git -C <path> branch --show-current`
2. Get the GitHub remote owner/repo: `git -C <path> config --get remote.origin.url` (parse `owner/repo` from SSH or HTTPS form)
3. Query the PR with `gh`:

   ```sh
   gh pr list --repo <owner/repo> --head <branch> --state all \
     --json number,state,title,url,mergedAt,closedAt --limit 1
   ```

4. Classify the worktree using the PR result:

| PR state                                          | Category          | Action                                                  |
| ------------------------------------------------- | ----------------- | ------------------------------------------------------- |
| No PR returned                                    | `no-pr`           | Keep. Do not propose deletion.                          |
| `state == OPEN`                                   | `open`            | Keep. Do not propose deletion.                          |
| `state == MERGED` (or `mergedAt` is set)          | `merged`          | Propose deletion.                                       |
| `state == CLOSED` and not merged                  | `closed-unmerged` | **Flag prominently** and propose deletion.              |

If `gh` is not authenticated or the repo is unreachable, classify as `unknown` and keep — do not propose deletion. Note these in the report.

### 4. Present a report and ask for confirmation

Show a grouped summary, ordered: `closed-unmerged` (flagged) → `merged` → `open`/`no-pr`/`unknown` (kept).

For each candidate for deletion, include: worktree path, branch, PR number + URL, and PR state. Example layout:

```
⚠ Closed without merge (flagged — work was abandoned):
  - ~/Development/twinkl-sanity-cms_CAPP-1234  feat/CAPP-1234-add-seo-tags  PR #789 (closed)  https://...

✅ Merged (safe to remove):
  - ~/Development/twinkl-web_CAPP-1500  fix/CAPP-1500-broken-link  PR #654 (merged)  https://...

⏸ Keeping (open / no PR / unknown):
  - ...
```

Then ask the user, via the `ask_user` tool, which worktrees to delete. Default to none selected. The user must opt in to each deletion (or confirm "all proposed").

### 5. Delete confirmed worktrees

For each confirmed worktree path, from inside the parent repository (or with an absolute path):

```sh
git -C <main-repo-path> worktree remove <worktree-path>
```

- Use the **main repo path**, not the worktree path itself, to avoid removing the worktree you are inside.
- If the worktree has uncommitted changes, `git worktree remove` will refuse. Surface the error to the user and ask whether to retry with `--force`. Never pass `--force` without an explicit per-worktree confirmation.
- Do **not** delete the feature branch as part of this skill — leave branch cleanup to the user or a separate workflow.

After each removal, run `git -C <main-repo-path> worktree prune` once at the end to clean up administrative metadata.

### 6. Final summary

Report:

- Worktrees deleted (with paths)
- Worktrees flagged but skipped
- Worktrees kept (open / no PR / unknown)
- Any errors

## Rules

- Never delete without explicit user confirmation per worktree (or a single explicit "delete all proposed").
- Never delete worktrees with `open` PRs, `no-pr`, or `unknown` PR state.
- Never delete the feature branch; only remove the worktree directory via `git worktree remove`.
- Closed-unmerged PRs must always be flagged in the report, even if the user later confirms deletion.
- If `gh` is not installed or not authenticated, stop and ask the user to authenticate before classifying.
