---
name: prd-to-project
description: Break a PRD into independently-grabbable task items on a GitHub Projects V2 board using tracer-bullet vertical slices. Use when user wants to convert a PRD into project tasks, break down a PRD for repos without GitHub Issues, or populate a project board with work items.
---

# PRD to Project

Break a PRD into independently-grabbable task items on a GitHub Projects V2 board using vertical slices (tracer bullets).

## Process

### 1. Locate the PRD

Ask the user for the Project board URL or name. Look up the board:

```bash
gh api graphql -f query='{ viewer { projectsV2(first: 20, query: "<board-name>") { nodes { id title number url shortDescription } } } }'
```

Find the PRD text. Check these locations in order:
1. Look for a draft item titled "PRD: ..." on the board — its body contains the full PRD
2. Fall back to the board's `shortDescription` (may be truncated)

If neither contains a PRD, ask the user to provide the PRD text directly.

Read the board title — this is the **slug** (e.g. `external-review`). The feature branch will be `feat/<slug>`.

**Note:** The `gh` token must have the `project` scope. If calls fail with `INSUFFICIENT_SCOPES`, tell the user to run `gh auth refresh -s project`.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.

### 3. Draft vertical slices

Break the PRD into **tracer bullet** tasks. Each task is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories from the PRD this addresses

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Create the Project items

For each approved slice, create a draft item on the board using `gh api graphql`.

**Title format:** `<NN> — <title>` where NN is the zero-padded task number (e.g. `01 — Entry point scaffolding`). This ensures tasks sort correctly by title.

Create items in dependency order (blockers first) so you can reference earlier items by number in the "Blocked by" field.

```bash
gh api graphql -f query='
mutation {
  addProjectV2DraftIssue(input: {
    projectId: "<PROJECT_ID>",
    title: "<NN> — <title>",
    body: "<task body using template below>"
  }) {
    projectItem { id }
  }
}'
```

All items are created with the default "Todo" status (no need to set status explicitly).

Ensure a "Blocked" status option exists on the board's Status field for use by `ralph-ext.sh` later. Check existing options and add it if missing:

```bash
# Get the Status field ID and its options
gh api graphql -f query='{ node(id: "<PROJECT_ID>") { ... on ProjectV2 { field(name: "Status") { ... on ProjectV2SingleSelectField { id options { id name } } } } } }'

# If "Blocked" is not in the options, add it (via updateProjectV2Field or inform the user)
```

<task-template>
## Parent PRD

Board: <board-name> (<board-url>)

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation. Reference specific sections of the parent PRD rather than duplicating content.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- Blocked by task NN (if any)

Or "None — can start immediately" if no blockers.

## User stories addressed

Reference by number from the parent PRD:

- User story 3
- User story 7

</task-template>

Do NOT delete or modify the PRD draft item on the board.

### 6. Summary

After creating all items, print a summary table:

| # | Title | Blocked by | User stories |
|---|-------|------------|-------------|
| 01 | ... | None | 1, 3 |
| 02 | ... | 01 | 2, 5 |

Tell the user that Ralph can start working on the first unblocked task with:
```
./ralph-ext.sh <iterations> --label=<slug>
```
