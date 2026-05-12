---
name: capp-run-preflight-checks
description: Run the standard CaPP workflow preflight before code or Jira/GitHub workflow actions. Confirms repo, branch, clean working tree, branch naming, repo docs, Jira context, package manager, checks, and safety constraints.
---

# CaPP Preflight

You are performing the shared preflight for CaPP workflow skills. The goal is to ensure the agent is operating in the right repo, on the right branch, with the right context, before making changes.

## Inputs

Expect some or all of:
- Jira ticket key
- PR URL or number
- Intended target repo
- Intended branch or branch type
- Whether code changes, Jira changes, GitHub changes, or review-only work will happen
- Affected packages/modules/files, if known

If required context is missing, infer it from the ticket/PR/repo where safe. Ask the developer when ambiguity could cause work in the wrong place.

## Outputs

Return a concise preflight summary:
- Target repo and current repo match status
- Current branch and whether it follows branch naming conventions
- Working tree status
- Relevant repo instructions found
- Jira ticket/PR context loaded
- Jira transitions/link types/fields needed for the workflow
- Package manager
- Check tiers from `capp-identify-repo-checks`
- Blockers or questions before work can proceed

## Required preflight

1. Confirm the current repository matches the ticket or PR.
   - If the target repo is unclear, infer from the ticket/PR links.
   - If the current directory appears wrong, stop and ask the developer to switch repos.
2. Read repo instructions:
   - AGENTS.md
   - CONTRIBUTING.md
   - PR templates
   - CONTEXT.md or equivalent domain/architecture docs
   - Package-level docs for affected areas
3. Check git state for code-changing work:
   - Confirm the current branch.
   - Confirm the branch is not the default branch unless the workflow is explicitly read-only.
   - Confirm the branch follows repo branch naming conventions. If the repo does not define one, use `<type>/<TICKET-ID>-<description>`.
   - Confirm there are no outstanding uncommitted changes before starting.
   - If outstanding changes exist, stop and ask whether to commit, stash, use a worktree, or switch branch. Do not mix unrelated local changes into the work.
4. Invoke `capp-get-jira-info` to load hardcoded CAPP Jira metadata (cloud ID, field IDs, transition map, link types). Use these values directly instead of discovering them via API.
5. Load Jira context when a ticket is involved:
   - Summary, description, acceptance criteria, links, comments, subtasks, and dependencies. Use `responseContentFormat: "markdown"` when reading fields.
   - Use transition IDs from `capp-get-jira-info` after validating the issue's current status matches the expected "From" status.
   - Check the field availability matrix in `capp-get-jira-info` before writing to Dev Notes (`customfield_26991`) or Story Points.
   - Use link type names from `capp-get-jira-info` (e.g. `"Blocks"`) when creating dependency links.
6. Load GitHub context when a PR is involved:
   - PR diff, description, files, comments, review threads, and latest head SHA when relevant.
   - PR template requirements from the repo.
7. Run `capp-identify-repo-checks` for code-changing work and record its tiered output.
8. Identify generated-file, lockfile, dependency, Sanity, infrastructure, or external-service constraints before changing files.

## Jira capability handling

CaPP Jira is expected to support this workflow. Do not over-defensively avoid Jira actions.

If a Jira field, transition, issue type, link type, assignee lookup, or sprint operation fails:
- Follow the fallback protocol in `capp-get-jira-info` — try hardcoded value, live discovery once, continue if unambiguous, report mismatch, ask user if ambiguous.
- If the developer is unavailable and a fallback is needed to preserve context, use a Jira comment rather than overwriting issue description or silently dropping information.
- For PRDs, fall back to a Jira comment titled `Technical PRD` if Dev Notes (`customfield_26991`) cannot be located or updated.

## PR template discovery

When preparing or checking a PR description, inspect:
1. `.github/pull_request_template.md`
2. `.github/PULL_REQUEST_TEMPLATE.md`
3. `.github/PULL_REQUEST_TEMPLATE/`
4. Repository-level `CONTRIBUTING.md` or PR guidance

Preserve required sections from the repo template. Do not invent repo-specific conventions that are not documented in repo instructions.

## Jira status rules

- Use transition IDs from `capp-get-jira-info` (e.g. Begin Work `2`, Done `6`) after confirming the issue's current status matches the expected "From" status.
- `In Review` (transition ID `3`) is the review status for the parent task.
- Skills may move implementation subtasks through their workflow, including to Done (transition ID `6`) when implementation is complete.
- No skill should move the parent task past `In Review`; moving the parent task to Done is a post-merge human or release workflow action.

## Safety rules

- Do not merge PRs.
- Do not force-push, rebase shared branches, delete branches, or discard local changes without explicit developer approval.
- Do not publish Sanity content or deploy infrastructure unless explicitly instructed.
- Do not commit secrets.
- Do not hand-edit generated files or lockfiles.
- Use repo-documented conventions over hardcoded CaPP-specific PR conventions.
