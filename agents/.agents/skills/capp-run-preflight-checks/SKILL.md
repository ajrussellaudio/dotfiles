---
name: capp-run-preflight-checks
description: CaPP workflow — preflight before code or Jira/GitHub actions (repo, branch, clean tree, naming, docs, Jira context, package manager, checks, safety). Internal; invoke explicitly.
---

# CaPP Preflight

Shared preflight for CaPP workflow skills: ensure the agent is in the right repo, on the right
branch, with the right context, before making changes.

**In:** ticket key; PR URL/number; intended repo and branch/type; what kind of work (code / Jira /
GitHub / review-only); affected files if known. Infer missing context from the ticket/PR/repo where
safe; ask when ambiguity could cause work in the wrong place.
**Out:** a concise summary — repo match; current branch + naming validity; working-tree status; repo
instructions found; Jira/PR context loaded; Jira transitions/links/fields needed; package manager;
check tiers from `capp-identify-repo-checks`; blockers/questions.

## Required preflight

1. **Repo match:** confirm the current repo matches the ticket/PR (infer from links). If the
   directory looks wrong, stop and ask to switch.
2. **Repo instructions:** AGENTS.md, CONTRIBUTING, PR templates, CONTEXT.md, package-level docs for
   affected areas.
3. **Git state (code-changing work):** confirm the current branch; confirm it's not the default
   branch (unless read-only); confirm naming (repo convention, else `<type>/<TICKET-ID>-<desc>`);
   confirm no uncommitted changes — if any, stop and ask whether to commit, stash, use a worktree,
   or switch (don't mix unrelated changes in).
4. **Jira metadata:** invoke `capp-get-jira-info` and use its values directly.
5. **Jira context (if a ticket):** summary, description, AC, links, comments, subtasks, dependencies
   (`responseContentFormat: "markdown"`). Validate current status before using a transition ID;
   check field availability before writing Dev Notes/Story Points; use link-type names for
   dependencies.
6. **GitHub context (if a PR):** diff, description, files, comments, review threads, latest head SHA;
   PR template requirements.
7. **Checks:** run `capp-identify-repo-checks` for code-changing work and record its tiers.
8. Identify generated-file, lockfile, dependency, Sanity, infra, or external-service constraints
   before changing files.

## Jira capability & fallback

CaPP Jira supports this workflow — don't over-defensively avoid Jira actions. On any failure, follow
the `capp-get-jira-info` fallback protocol. If the developer is unavailable and context would be
lost, use a comment rather than overwriting the description. For PRDs, fall back to a `Technical PRD`
comment only if Dev Notes can't be located/updated.

## PR template discovery

Follow `capp-conventions` (check `.github` template paths, then CONTRIBUTING; preserve required
sections; don't invent conventions).

## Jira status rules

Use transitions from `capp-get-jira-info` (Begin Work `2`, Done `6`) after confirming the current
status. `In Review` (`3`) is the parent task's review status. Skills may move implementation
subtasks through to Done. **No skill moves the parent task past In Review** — moving it to Done is a
post-merge human/release action.

## Safety rules

- Don't merge PRs; don't force-push, rebase shared branches, delete branches, or discard local
  changes without explicit approval.
- Don't publish Sanity content or deploy infrastructure unless instructed.
- Don't commit secrets or hand-edit generated files/lockfiles.
- Prefer repo-documented conventions over hardcoded CaPP-specific PR conventions.
