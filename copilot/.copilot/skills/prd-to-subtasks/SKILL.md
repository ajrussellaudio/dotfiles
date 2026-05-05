---
name: prd-to-subtasks
description: Break a PRD on a JIRA ticket into independently-grabbable sub-tasks using tracer-bullet vertical slices. Use when user wants to convert a JIRA PRD ticket into sub-tasks for Ralph.
---

# PRD to Sub-tasks (JIRA)

Break a PRD stored on a JIRA ticket into independently-grabbable JIRA sub-tasks using vertical slices (tracer bullets).

This is the JIRA counterpart of `/prd-to-issues`. Use it when the parent PRD lives in JIRA — either as a fresh ticket created via `/write-a-prd` Option C, or as Dev Notes appended to an existing ticket via Option D.

Use the Atlassian MCP tools (prefixed `atlassian-rovo-mcp-`) — not jira-cli — for all JIRA operations in this skill.

## Process

### 1. Locate the parent PRD ticket

Ask the user for the JIRA ticket key (e.g. `CAPP-123`) or URL.

Resolve the cloudId. Try the user's site hostname first, or call `getAccessibleAtlassianResources` if unknown.

Fetch the ticket with `getJiraIssue`. Read:

- The ticket's **description** (PRD body, if Option C was used)
- The ticket's **Dev Notes** custom field (PRD body, if Option D was used) — find its `customfield_*` ID via `getJiraIssueTypeMetaWithFields` if needed
- The **project key** (e.g. `CAPP`) — derived from the ticket key
- The ticket's **issue type** (Story, Epic, Task, etc.)

If the ticket is itself a Sub-task, push back — Ralph expects the parent to be a top-level ticket so it can iterate over its sub-tasks.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.

### 3. Draft vertical slices

Break the PRD into **tracer bullet** sub-tasks. Each is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

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
- **Issue type**: Sub-task by default. Ralph maps the sub-task issue type to a branch prefix:
  - `Bug` → `fix/`
  - `Improvement` → `refactor/`
  - everything else → `feat/`
  Only flag a slice as a non-default issue type if the project's JIRA config supports it as a sub-task type (e.g. some configs have "Sub-bug").
- **Priority**: `Highest` / `High` / `Medium` / `Low` / `Lowest`. Ralph orders sub-tasks by Priority (desc) with ticket-key tie-break, so this controls the order Ralph picks them up.
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories from the PRD this addresses

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?
- Are the priorities right? (the highest-priority slice will be picked up first)

Iterate until the user approves the breakdown.

### 5. Create the JIRA sub-tasks

For each approved slice, create a sub-task using `createJiraIssue`. Create them in dependency order (blockers first) so you have real ticket keys to reference in the "is blocked by" links.

Required fields:
- `projectKey`: the parent's project key
- `issueTypeName`: `Sub-task` (or the override from step 4)
- `parent`: the parent PRD ticket key (e.g. `CAPP-123`)
- `summary`: short descriptive title
- `description`: from the sub-task body template below (use `contentFormat: "markdown"`)
- `additional_fields`: `{"priority": {"name": "<Priority>"}}` to set the priority

After creating each sub-task, link any "Blocked by" relationships using `createIssueLink` with type `Blocks`:
- `inwardIssue`: the blocker (the sub-task that must complete first)
- `outwardIssue`: the blocked (the sub-task that depends on it)
- `type`: `Blocks`

This corresponds to "outward is blocked by inward" semantically. Verify with `getIssueLinkTypes` if the project uses different naming.

<subtask-body-template>
## Parent PRD

<parent-ticket-key> — link automatic via JIRA parent field

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation. Reference specific sections of the parent PRD rather than duplicating content.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- Blocked by <ticket-key> (if any)

Or "None - can start immediately" if no blockers.
The actual blocking is enforced by the JIRA "is blocked by" link, not by this text — Ralph reads the links, not the description.

## User stories addressed

Reference by number from the parent PRD:

- User story 3
- User story 7
</subtask-body-template>

Do NOT modify the parent PRD ticket's status or description.

### 6. Report back

Print a numbered list of the created sub-task keys with their titles, plus the parent ticket URL. Tell the user they can start Ralph with `ralph run --ticket=<parent-ticket-key>`.
