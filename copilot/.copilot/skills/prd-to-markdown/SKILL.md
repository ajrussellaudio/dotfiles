---
name: prd-to-markdown
description: Break a PRD into independently-grabbable task files under ./plans/<slug>/ using tracer-bullet vertical slices. Each task becomes a numbered Markdown file with YAML front matter for Ralph to consume. Use when user wants to convert a PRD into local task files for Ralph's Markdown backend.
---

# PRD to Markdown Tasks

Break a PRD into independently-grabbable task files using vertical slices (tracer bullets).

## Process

### 1. Locate the PRD

Ask the user for the PRD slug or path (e.g. `foo-widget` → `./plans/foo-widget.md`).

If the PRD is not already in your context window, read it from `./plans/<slug>.md`.

The slug in the PRD's YAML front matter (`label: <slug>`) is the **feature slug** — it determines the task directory: `./plans/<slug>/`.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.

### 3. Draft vertical slices

Break the PRD into **tracer bullet** task slices. Each slice is a thin vertical cut through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

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

### 5. Create the task files

For each approved slice, create a Markdown task file at:

```
./plans/<slug>/<NN>-<kebab-case-title>.md
```

Where `<NN>` is a zero-padded sequential number starting at `01` (e.g. `01`, `02`, `03`...).

Create files in dependency order (blockers first) so you can reference real task numbers in the `blocked_by` field.

Each file must have YAML front matter followed by the task body:

<task-file-template>
```markdown
---
title: <Title of this task>
priority: normal
blocked_by: []
status: pending
branch: ""
review_notes: []            # Ralph appends a new entry after each review round
fix_count: 0
---

## Parent PRD

`plans/<slug>.md`

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## User stories addressed

Reference by number from the parent PRD:

- User story 3
- User story 7
```
</task-file-template>

**Front matter field rules:**
- `priority`: `normal` or `high`
- `blocked_by`: list of task numbers (the `NN` prefix) that must be `done` first, e.g. `[1, 2]`. Use `[]` if none.
- `status`: always `pending` for newly created files — Ralph manages this field
- `review_notes`: always `[]` — Ralph appends a new `|` literal block scalar entry after each review round; never use quoted strings (colons and special chars would break YAML)

Create the task directory and files:
```bash
mkdir -p "./plans/<slug>"
# then write each file, e.g.:
cat > "./plans/<slug>/01-<kebab-title>.md" << 'EOF'
---
title: ...
...
---

...
EOF
```

Do NOT modify the parent PRD file (`./plans/<slug>.md`).
