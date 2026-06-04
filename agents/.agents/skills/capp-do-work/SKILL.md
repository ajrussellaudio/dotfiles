---
name: capp-do-work
description: CaPP workflow — implement a Jira ticket via TDD subtasks, focused commits, and a draft PR (or a small bug as one unit). Invoke explicitly.
---

# CaPP Do the Work

Implement a Jira ticket subtask-by-subtask: each subtask gets a commit, the whole ticket yields one
draft PR.

**Step 4** of the CaPP workflow, after `capp-prd-to-subtasks`. Also used directly for small,
well-defined bugs after `capp-create-a-ticket`.

**In:** ticket key; Agent subtasks (or a small bug with clear AC); repo/branch context; check tiers
from `capp-run-preflight-checks`.
**Out:** a correctly named branch; focused commits (one per Agent subtask, or one for a single
bug); updated subtasks; a draft PR following the repo template; a validation summary.

## Preflight

1. Ask for the ticket key if not provided.
2. Run `capp-run-preflight-checks` for the ticket and target repo — this loads Jira metadata via
   `capp-get-jira-info` (transitions Begin Work `2`, Done `6`; Dev Notes field; Subtask type) and
   runs `capp-identify-repo-checks` (use its tiers as the validation plan).
3. Read the ticket (summary, description, AC, Dev Notes / `Technical PRD` comment) and its subtasks,
   types, and dependencies — `responseContentFormat: "markdown"`.
4. **If subtasks exist:** implement Agent subtasks only; skip Human ones; if an Agent subtask
   depends on an unresolved Human subtask, pause and ask.
5. **If no subtasks:** proceed only if it's a small, well-defined bug with clear AC (treat the
   ticket as one unit). Otherwise encourage `capp-prd-to-subtasks` first — do not proceed.

## Setup

### Branch

1. Confirm you're on the correct starting branch with no uncommitted changes.
2. **Always offer a git worktree** for parallel work, named `<repo-path>_<PARENT-TICKET-ID>` (e.g.
   `~/Development/twinkl-sanity-cms_CAPP-1234`). If declined, continue in the current tree.
3. Create/confirm a feature branch `<type>/<TICKET-ID>-<description>` (e.g.
   `feat/CAPP-1234-add-seo-tags`); ask if it breaks repo naming conventions. Create it in the
   worktree if using one.

### Early PR (schema work)

Schema/content/UI should ideally be separate tickets/PRs. For a schema-only ticket (or a confirmed
combined bug): make schema changes first, run the documented Sanity typegen flow, and create the
draft PR early after the first schema commit if downstream typegen needs `--pr <pr-num>`. Keep
pushing subsequent commits to it.

## Implementation loop

For each subtask (or the single bug), in dependency order:

1. **Pick up:** assign to "me" and move to In Progress (transition `2`, after confirming it's in
   To Do). Skip Human subtasks.
2. **TDD (red-green-refactor):** write/modify a failing test → confirm it fails → minimal
   implementation → confirm it passes → refactor green. When TDD isn't practical (config, structural
   moves, generated code), note why in the commit and still cover the change with tests.
3. **Targeted checks:** run the targeted tier before committing (affected tests, the exact failed
   check, package-local lint/typecheck, generated type/schema checks). Fix failures, re-run, broaden
   to affected-package checks if impact looks wider.
4. **Local review:** review independently per `capp-conventions` (separate agent where available).
   Private only — do NOT post to GitHub. Focus: AGENTS.md conventions, correctness/edge cases,
   security, obvious bugs. Fix findings, re-check, re-review.
5. **Commit:** focused conventional commit referencing the ticket (e.g.
   `feat(resource): add review filtering logic [CAPP-1234]`).
6. **Complete:** move the subtask to Done (transition `6`, after confirming it's In Progress).
7. **Next** unblocked subtask. Repeat.

**⚠️ Cost discipline:** Each subtask should run in a **separate agent session** (do NOT invoke
`capp-do-work` with multiple subtasks in one session; invoke once per subtask). This prevents
context accumulation — each subtask gets fresh context, keeps tokens low (~$0.30–$0.50 per
subtask), and isolates failures. If a subtask fails, the next one doesn't inherit the failure
context. This is why tight scoping (tight subtasks × separate sessions) = efficient, low-cost
implementation.

## Failure handling

If a subtask fails after **3 attempts:** escalate (explain what was tried); if the developer is
unavailable, skip only to a genuinely independent subtask; mark the blocked subtask with a Jira
comment. Debugging: undo and retry smaller increments; small in-scope refactors; read errors
carefully — common gotchas: **Sanity typegen** (use the documented command or `--pr <pr-num>`;
never edit generated types), **import paths** (check exports/barrels), **test mocking** (prefer
real components).

## Finalisation

1. **Final checks:** run all locally-runnable checks before pushing, per `capp-conventions`
   (CI should pass on first push). Fix any failure first.
2. **CONTEXT.md:** if present, update with new domain terms/patterns/decisions.
3. **PR:** create a **draft** (if not already created for typegen), link the parent ticket, target
   the default branch, and follow the repo PR template (discovery in `capp-conventions`). Include
   ticket, summary, testing/validation, AC coverage, and notable trade-offs.
4. **Push** and confirm the PR.

## Rules

- **Sequential only** — no parallel agents for implementation (they conflict on disk).
- **1 ticket = 1 PR** (CMS schema vs UI splitting per `capp-conventions`).
- Do NOT make destructive Jira changes without approval, merge the PR, or move the **parent** task
  past Review (subtasks may go to Done).
