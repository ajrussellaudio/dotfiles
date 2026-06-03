---
name: capp-do-work
description: Implement a Jira ticket by iteratively completing subtasks using TDD. Creates a feature branch, one commit per subtask, and a draft PR. Also handles small well-defined bugs without subtasks. Use when ready to start coding.
---

# CaPP Do the Work

You are implementing a Jira ticket by working through its subtasks one at a time. Each subtask gets a commit, and the whole ticket results in one draft PR.

## Workflow Position

This is the **fourth step** in the CaPP development workflow, after `capp-prd-to-subtasks`. It can also be used directly for small, well-defined bugs or tasks after `capp-create-a-ticket`.

## Inputs

Expect:
- Jira ticket key
- Agent subtasks from `capp-prd-to-subtasks`, or a small well-defined bug/task with clear acceptance criteria
- Repo context, target branch, and acceptance criteria
- Check tiers from `capp-identify-repo-checks` via `capp-run-preflight-checks`

## Outputs

Produce:
- A correctly named feature branch
- Focused commits, one per Agent subtask or one for the single bug/task unit
- Updated implementation subtasks
- A draft PR following repo PR template/docs
- Validation summary using targeted and required local check tiers

## Preflight

1. Ask for the Jira ticket key if not provided
2. Invoke `capp-get-jira-info` to load hardcoded CAPP Jira metadata — in particular, transition IDs (Begin Work `2`, Done `6`), Dev Notes field ID (`customfield_26991`), and Subtask issue type ID (`21352`)
3. Run `capp-run-preflight-checks` for the ticket and target repo
4. Read the Jira ticket — summary, description, acceptance criteria, Dev Notes (`customfield_26991`) or `Technical PRD` comment. Use `responseContentFormat: "markdown"` when reading fields
5. Read the ticket's subtasks, their types, and their dependencies
5. **If subtasks exist**:
   - Implement Agent subtasks only
   - Skip Human subtasks
   - If an Agent subtask depends on an unresolved Human subtask, pause and ask the developer
6. **If no subtasks**:
   - Check if this is a small, well-defined bug with clear acceptance criteria
   - If yes: proceed as a single unit of work (treat the ticket itself as one subtask)
   - If no: encourage the developer to run `capp-prd-to-subtasks` first — do not proceed
7. Use the `capp-identify-repo-checks` output from preflight as the validation plan

## Setup

### Branch

1. Ensure you are on the correct starting branch for the work
2. Confirm there are no outstanding uncommitted changes before creating or using a branch
3. **Always offer to create a git worktree** for this work. Worktrees allow parallel work on multiple tickets without stashing or switching branches. Suggest the worktree path as the current repo directory with a `_<TICKET-ID>` suffix using the **parent task** ID (not a subtask ID) — e.g. if the repo is at `~/Development/twinkl-sanity-cms` and the parent ticket is `CAPP-1234`, suggest `~/Development/twinkl-sanity-cms_CAPP-1234`. If the developer declines, continue in the current working tree.
4. Create or confirm a feature branch: `<type>/<TICKET-ID>-<description>`
   - e.g. `feat/CAPP-1234-add-seo-tags`
5. If the branch does not follow repo naming conventions, ask before continuing
6. If using a worktree, create the feature branch in the new worktree directory

### Early PR (if needed)

Schema/content/UI changes should ideally be separate tickets and PRs. If the work is a schema-only ticket, or a small bug/task where the developer confirms schema and UI changes must stay together:
- Make schema changes first
- Generate/update schema types through the documented Sanity typegen flow
- Create the draft PR early after the first schema commit if downstream typegen needs `sanity typegen --pr <pr-num>`
- Continue pushing subsequent commits to this PR

## Implementation Loop

For each subtask (or the single bug), in dependency order:

### 1. Pick up the subtask
- Assign the subtask to the developer (i.e. the current user — "me") and move it to **In Progress** using transition ID `2` (Begin Work) from `capp-get-jira-info`. Confirm the subtask is in To Do before using this transition — if it's in a different status, consult the transition map in `capp-get-jira-info`
- Do not pick up Human subtasks

### 2. Implement with TDD

Follow red-green-refactor where practical:

1. **Red**: Identify expected behaviour → write or modify a failing test → run the test to confirm it fails
2. **Green**: Write the minimum implementation to make the test pass → confirm it passes
3. **Refactor**: Clean up while keeping tests green

**When TDD isn't practical** (config changes, structural moves, generated code):
- Note in the commit message why TDD was skipped
- Still add or update tests to cover the change

### 3. Run targeted checks

Run the **targeted** checks identified by `capp-identify-repo-checks` before each commit:
- Affected tests
- The exact failed check after a fix
- Package-local lint/typecheck where available
- Generated type/schema checks when changed inputs require them

Fix any failures before proceeding. If a check fails:
1. Fix the issue
2. Re-run the targeted check that failed
3. Broaden to affected-package checks if failures suggest wider impact
4. Repeat until the targeted tier passes

### 4. Local review

Use a **separate agent** for review where available, especially for substantial, risky, security, data-fetching, Sanity, or cross-package changes. If sub-agents are not available, perform an equivalent separate-pass review yourself. This is a private, local review — do NOT post comments to GitHub.

Review focus:
- Adherence to repo conventions (AGENTS.md)
- Correctness and edge cases
- Security concerns
- Obvious bugs

If the review finds issues, fix them, re-run checks, and re-review.

### 5. Commit

Make a focused commit for this subtask:
- Use conventional commit format referencing the ticket
- e.g. `feat(resource): add review filtering logic [CAPP-1234]`

### 6. Complete the subtask
- Move the implementation subtask to **Done** using transition ID `6` from `capp-get-jira-info` once its commit is complete and targeted checks pass. Confirm the subtask is in In Progress before using this transition

### 7. Next subtask

Move to the next unblocked subtask in dependency order. Repeat until all subtasks are complete.

## Failure Handling

If a subtask fails after **3 attempts**:
1. Escalate to the developer — explain what was tried and what failed
2. If the developer is unavailable, skip to the next unblocked subtask only if it is genuinely independent
3. Mark the blocked subtask with a comment in Jira explaining the blocker

**Debugging strategies:**
- Undo and retry with smaller, more incremental changes
- Small refactors to unblock (only within the subtask's scope)
- Read error messages carefully — common gotchas:
  - **Sanity typegen**: use the documented typegen command for local schemas or `--pr <pr-num>` for unreleased schemas. Never manually edit generated types
  - **Import paths**: check package exports and barrel files
  - **Test mocking**: prefer real components over mocks where possible

## Finalisation

After all subtasks are complete:

### 1. Final checks

**Goal: CI should pass on the first push.** Run every check from `capp-identify-repo-checks` that can run locally before pushing:

- **All required local checks** — lint, typecheck, unit tests, format, build (if CI requires it)
- **All conditional checks relevant to the changed area** — coverage, Sanity typegen/schema, bundle-size, infrastructure plan/validate, integration tests, etc.
- **CI-only checks** — only skip checks that genuinely cannot run locally (secrets, deployed services, browsers, external datasets). Document which CI-only checks will run on push so the developer knows what to watch for.

If any check fails, fix it and re-run before pushing. Do not push hoping CI will catch what you skipped.

### 2. CONTEXT.md

If a CONTEXT.md file exists in the repo or affected packages, update it with any new domain terms, patterns, or architectural decisions introduced by this work.

### 3. Create or update the PR

If not already created (for Sanity typegen):
- Create a **draft** PR
- Link to the parent Jira ticket (not individual subtasks)
- Target the default branch

**PR description** should follow the repo's PR template and repo docs. Discover templates in:
1. `.github/pull_request_template.md`
2. `.github/PULL_REQUEST_TEMPLATE.md`
3. `.github/PULL_REQUEST_TEMPLATE/`
4. CONTRIBUTING.md or repo docs

Include the Jira ticket, summary of changes, testing/validation approach, acceptance criteria coverage, and noteworthy decisions or trade-offs where the template asks for them.

### 4. Push

Push the branch and confirm the PR is created/updated.

## Rules

- **Sequential only** — do NOT run parallel agents for implementation. They conflict on disk
- **1 ticket = 1 PR** in a single repo. CMS schema/content and UI changes should ideally be separate tickets and PRs unless the developer explicitly confirms a small bug/task should stay together
- **Do NOT skip validation** — run targeted checks before every commit and all locally-runnable checks (required + applicable conditional) before pushing. CI should pass on first push
- **Do NOT manually edit generated files or lockfiles**. Regenerate them through the documented tool/package manager when required
- **Do NOT make destructive changes to Jira** without developer approval
- **Do NOT merge the PR** — that is a human action
- **Do NOT move the parent Jira task past Review**. Subtasks may move to Done when implementation is complete
