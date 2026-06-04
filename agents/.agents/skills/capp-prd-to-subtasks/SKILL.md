---
name: capp-prd-to-subtasks
description: CaPP workflow — break a PRD'd Jira ticket into approved, agent-ready subtasks with dependency links. Invoke explicitly.
---

# CaPP PRD to Subtasks

Break a Jira ticket into subtasks that agents can pick up and implement. Each subtask is a
self-contained unit that yields a testable, demoable increment.

**Step 3** of the CaPP workflow, after `capp-write-prd` (ticket should have a PRD in Dev Notes).
Small bugs may skip straight to `capp-do-work`.

**In:** parent ticket; PRD from Dev Notes (or a `Technical PRD` comment); AC, links, affected
modules, constraints, rollout notes, testing strategy.
**Out:** approved Jira subtasks, each with parent context, target repo, goal, type (Agent/Human),
affected area, AC covered, constraints/out-of-scope, validation hints, and dependency links.

## Preflight

1. Ask for the ticket key if not provided.
2. Run `capp-run-preflight-checks` for the ticket and target repo — this loads Jira metadata via
   `capp-get-jira-info` (Subtask type `21352`, Blocks link `10000`, Dev Notes field).
3. Read the ticket and PRD (Dev Notes, else a `Technical PRD` comment) —
   `responseContentFormat: "markdown"`. If no PRD, encourage running `capp-write-prd` first.

## Process

### 1. Analyse

Goal and AC, affected modules/patterns, testing requirements, ordering constraints, rollout and
out-of-scope.

### 2. Design the breakdown

- Prefer **vertical slices** (end-to-end value); use **horizontal** only when vertical doesn't make
  sense (shared utils, schema setup). Each subtask should be QAable/demoable in isolation.
- **Type:** Agent (fully AI-implementable) or Human (needs judgment, manual testing, or external
  access). `capp-do-work` skips Human subtasks and pauses if an Agent subtask depends on an
  unresolved Human one.
- CMS schema/content/UI should be **separate tickets** (own PR per repo), not subtasks, per
  `capp-conventions` — flag and create linked tickets instead.
- Subtasks define the **WHAT**, not the HOW, but include constraints, patterns, affected modules,
  and validation hints to make them agent-ready. Each must reference the parent for context.

**⚠️ Tight scoping requirement:** Each subtask must be summariasable in **<5 lines** and map to a
**single logical unit of work** (one function, one file, one feature). If a subtask requires changes
across >2 modules or touches >1 layer (schema + API + UI), it should be split further. Tightly scoped
subtasks keep each `capp-do-work` session cost-efficient (~$0.30–$0.50 per subtask) by preventing
context bloat. Validate by asking: "Could a junior engineer complete this in 30–60 minutes?" If no,
split it.

### 3. Present for approval

Show a preview table, then batch-create only on explicit approval:

| # | Subtask | Goal | Type | Depends on | Validation |
|---|---------|------|------|------------|------------|

### 4. Create subtasks in Jira

For each approved subtask, create under the parent with a description covering: parent context,
target repo, goal, type, affected area, AC covered, constraints/out-of-scope, validation, notes.
Link dependencies with `Blocks` (`10000`): inward = blocker, outward = blocked; pass
`type: "Blocks"` to `createIssueLink`. On link failure, follow the `capp-get-jira-info` fallback;
if the developer is unavailable, record dependencies in descriptions/comments.

## Rules

- Do NOT create subtasks without explicit approval, or prescribe non-essential implementation detail.
- Keep descriptions concise but self-contained — understandable from the subtask plus parent.
