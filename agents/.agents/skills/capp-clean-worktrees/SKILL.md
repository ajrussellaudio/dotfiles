---
name: capp-clean-worktrees
description: Tidy up CaPP git worktrees whose PRs are merged or closed-unmerged. Scans for `<repo>_<TICKET-ID>` worktrees, looks up each PR via `gh`, flags closed-unmerged, and removes only after explicit per-worktree confirmation. Use to clean up or prune CAPP worktrees.
---

# CaPP Clean Worktrees

Identify CaPP worktrees whose work is finished (PR merged) or abandoned (PR closed unmerged) and
remove them safely. **Never delete without confirmation.**

## Worktree convention (from `capp-do-work`)

- Path `<repo-path>_<TICKET-ID>` — e.g. `~/Development/twinkl-sanity-cms_CAPP-1234`.
- TICKET-ID is the **parent** ticket, `<UPPERCASE>-<DIGITS>` (e.g. `CAPP-1234`, `WEB-987`).
- Each has a feature branch like `feat/CAPP-1234-add-seo-tags`.

## Workflow

### 1. Choose search root

List directories in cwd; if any contain a `.git` file/dir (repos/worktrees in cwd), use cwd as the
root, else fall back to `~/Development`. State the chosen root before scanning.

### 2. Discover candidates

```sh
find <search-root> -maxdepth 2 -type d -name '*_[A-Z][A-Z]*-[0-9]*'
```

Confirm each is a **linked** worktree (`git -C <path> rev-parse --is-inside-work-tree` is `true`
and `--git-common-dir` differs from `<path>/.git`). Skip regular clones / non-git dirs.

### 3. Resolve PR state per worktree

1. Branch: `git -C <path> branch --show-current`
2. Remote owner/repo: parse `git -C <path> config --get remote.origin.url` (SSH or HTTPS).
3. `gh pr list --repo <owner/repo> --head <branch> --state all --json number,state,title,url,mergedAt,closedAt --limit 1`
4. Classify:

| PR state | Category | Action |
|----------|----------|--------|
| No PR returned | `no-pr` | Keep |
| `OPEN` | `open` | Keep |
| `MERGED` (or `mergedAt` set) | `merged` | Propose deletion |
| `CLOSED` and not merged | `closed-unmerged` | **Flag prominently** + propose deletion |

If `gh` is unauthenticated or the repo is unreachable, classify `unknown` and keep (note in report).

### 4. Report and confirm

Show a grouped summary ordered: `closed-unmerged` (flagged) → `merged` → kept (`open`/`no-pr`/
`unknown`). For each deletion candidate include path, branch, PR number + URL, and state:

```
⚠ Closed without merge (abandoned):
  - ~/Development/twinkl-sanity-cms_CAPP-1234  feat/CAPP-1234-add-seo-tags  PR #789 (closed)  https://...
✅ Merged (safe to remove):
  - ~/Development/twinkl-web_CAPP-1500  fix/CAPP-1500-broken-link  PR #654 (merged)  https://...
⏸ Keeping (open / no PR / unknown): ...
```

Then use `ask_user` to confirm which to delete — default none; opt in per worktree (or "all
proposed").

### 5. Delete confirmed worktrees

From the **main repo path** (not the worktree, to avoid removing the one you're in):

```sh
git -C <main-repo-path> worktree remove <worktree-path>
```

If it refuses due to uncommitted changes, surface the error and ask whether to retry with `--force`
(never `--force` without explicit per-worktree confirmation). Do **not** delete the feature branch.
Run `git -C <main-repo-path> worktree prune` once at the end.

### 6. Final summary

Report: deleted (paths), flagged-but-skipped, kept (open/no-pr/unknown), and any errors.

## Rules

- Never delete without explicit per-worktree confirmation (or one explicit "delete all proposed").
- Never delete worktrees with `open`, `no-pr`, or `unknown` state, nor the feature branch.
- Always flag closed-unmerged PRs, even if the user later confirms deletion.
- If `gh` is not installed/authenticated, stop and ask the user to authenticate first.
