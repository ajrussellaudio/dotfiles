---
name: capp-prd-to-subtasks
description: Break a Jira ticket with a PRD into agent-ready subtasks. Creates Jira subtasks with dependencies for implementation by the do-the-work skill. Use after writing a PRD.
---

# CaPP PRD to Subtasks

You are helping a developer break down a Jira ticket into subtasks that agents can pick up and implement. Each subtask should be a self-contained unit of work that results in a testable, demoable increment.

## Workflow Position

This is the **third step** in the CaPP development workflow, after `capp-write-prd`. The ticket should have a PRD in the Dev Notes field before running this skill.

Small, well-defined bugs or tasks may skip this step and go directly to `capp-do-work`. Standard feature work should use subtasks.

## Inputs

Expect:
- Jira parent ticket
- PRD from Dev Notes or a `Technical PRD` Jira comment
- Acceptance criteria, links, comments, affected modules, constraints, rollout notes, and testing strategy

## Outputs

Create approved Jira subtasks with a loose but consistent contract:
- Parent context and target repo
- Goal and user-facing outcome
- Type: Agent or Human
- Affected area/modules
- Acceptance criteria covered
- Constraints and out-of-scope notes
- Validation hints
- Dependencies and links where Jira supports them

## Preflight

1. Ask for the Jira ticket key if not provided
2. Invoke `capp-get-jira-info` to load hardcoded CAPP Jira metadata — in particular, Subtask issue type ID (`21352`), Blocks link type (ID `10000`, name `"Blocks"`), and Dev Notes field ID (`customfield_26991`)
3. Run `capp-run-preflight-checks` for the ticket and target repo
4. Read the Jira ticket — summary, description, acceptance criteria, Dev Notes (`customfield_26991`), and comments. Use `responseContentFormat: "markdown"` when reading fields
5. If no PRD exists in Dev Notes, look for a Jira comment titled `Technical PRD`
6. If no PRD exists, encourage the developer to run `capp-write-prd` first

## Process

### 1. Analyse the work

Read the ticket and PRD to understand:
- The overall goal and acceptance criteria
- Affected modules and patterns
- Testing requirements
- Dependencies and ordering constraints
- Rollout/release constraints and out-of-scope items

### 2. Design the breakdown

**Slice approach:**
- Prefer **vertical slices** — each subtask delivers end-to-end value where possible
- Use **horizontal slices** when vertical doesn't make sense (e.g. shared utilities, schema setup)
- Each subtask should aim to be QAable or demoable in isolation

**Slice types:**
- **Agent** — can be fully implemented by an AI agent
- **Human** — requires human judgment, manual testing, or access to external systems

Human subtasks are not for `capp-do-work` to implement. If an Agent subtask depends on an unresolved Human subtask, the implementation skill should pause and ask the developer.

**Important:**
- CMS schema, content, and UI changes should ideally be **separate tickets** (not subtasks), each resulting in their own PR in their respective repo. If the PRD includes both for standard feature work, flag this and create linked tickets instead. If the developer confirms this is a small bug/task that must stay together, document schema-first ordering so generated schema types are available before UI work
- Subtasks define the **WHAT**, not the HOW. Include technical constraints, existing patterns, affected modules, and validation hints where they make the work agent-ready
- Each subtask must reference the parent ticket for context — the agent working on it needs to understand the bigger picture

### 3. Present for approval

Before creating subtasks, show a preview:

| # | Subtask | Goal | Type | Depends on | Validation |
|---|---------|------|------|------------|------------|
| 1 | ... | ... | Agent/Human | — | How to verify |
| 2 | ... | ... | Agent | #1 | How to verify |

Accept tweaks from the developer, then batch-create all subtasks on explicit approval.

### 4. Create subtasks in Jira

For each approved subtask:
1. Create as a Jira subtask under the parent ticket
2. Include in the description:
    - **Parent context**: Reference to the parent ticket and its goal
    - **Target repo**: Repo this subtask belongs to
    - **Goal**: What this subtask achieves
    - **Type**: Agent or Human
    - **Affected area**: Package/module/route/schema area involved
    - **Acceptance criteria**: Parent criteria this subtask helps satisfy
    - **Constraints / out of scope**: Boundaries the agent must preserve
    - **Validation**: How to verify the subtask is complete
    - **Notes**: Any noteworthy implementation details
3. Link dependencies between subtasks using the `Blocks` link type (ID `10000`) from `capp-get-jira-info`:
    - Inward issue = the blocker (the task that must complete first)
    - Outward issue = the blocked task (the task that is waiting)
    - Pass `type: "Blocks"` to `createIssueLink` (the MCP tool accepts the name)
4. If link types or subtask links fail unexpectedly, follow the fallback protocol in `capp-get-jira-info`. If the developer is unavailable, record dependencies in the subtask descriptions/comments.

## Rules

- Do NOT create subtasks without explicit developer approval
- Do NOT prescribe implementation details unless they are essential
- Do NOT create subtasks for CMS schema changes under a UI ticket for standard feature work — these should be separate tickets unless the developer explicitly confirms a small bug/task should stay together
- Keep subtask descriptions concise but self-contained — an agent should be able to understand the work from the subtask alone plus the parent ticket
