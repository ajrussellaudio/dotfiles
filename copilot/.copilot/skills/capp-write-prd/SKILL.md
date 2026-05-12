---
name: capp-write-prd
description: Create a technical PRD for a Jira ticket by reading the ticket, exploring the codebase, and interviewing the developer. Outputs to Jira Dev Notes (with a Technical PRD comment only as a last-resort fallback). Use when a developer picks up a feature or complex task and needs to plan the implementation.
---

# CaPP Write PRD

You are helping a developer create a technical PRD (Product Requirements Document) for a Jira ticket they are about to work on. The PRD captures the implementation approach, technical direction, and scope.

## Workflow Position

This is the **second step** in the CaPP development workflow, after `capp-create-a-ticket`. The developer has picked up a ticket and needs to plan the technical approach before breaking it into subtasks.

Small, well-defined bugs or tasks may skip this step and go from `capp-create-a-ticket` directly to `capp-do-work`. Standard feature work should use this PRD step.

## Inputs

Expect:
- Jira ticket key
- Ticket summary, description, acceptance criteria, comments, and links
- Existing technical context from repo docs and developer interview

## Outputs

Produce a concise technical PRD in the Jira **Dev Notes** field. A `Technical PRD` Jira comment is a **last-resort fallback** — only acceptable when (a) the issue type does not support Dev Notes (e.g. Subtask), or (b) a Dev Notes write has actually been attempted in ADF format and failed. Do not fall back to a comment without first attempting the ADF write.

The PRD should include affected modules, relevant file paths where helpful, testing strategy, rollout/release considerations, risks, out-of-scope items, and acceptance-criteria traceability.

## Preflight

1. Ask for the Jira ticket key (e.g. CAPP-1234) if not provided
2. Invoke `capp-get-jira-info` to load hardcoded CAPP Jira metadata — in particular, Dev Notes field ID (`customfield_26991`), transition IDs (Begin Work `2`), and content format guidance
3. Run `capp-run-preflight-checks` for the ticket and target repo
4. Read the Jira ticket — summary, description, acceptance criteria, links, comments. Use `responseContentFormat: "markdown"` when reading fields
5. Confirm the issue type supports Dev Notes (`customfield_26991`) — see the field availability matrix in `capp-get-jira-info`. Dev Notes is the required target. Only if the issue type does not support Dev Notes at all (e.g. Subtask) should you plan to use a Jira comment titled `Technical PRD`. Do not pre-emptively choose the comment fallback for any other reason
6. Do NOT ask the developer to re-describe the work from scratch — use the ticket as the starting point

## Process

### 1. Explore the codebase

- **High-level**: Understand the repo structure, key packages, architectural patterns
- **Targeted**: Deep-dive into the areas affected by this ticket
- Read AGENTS.md if present for repo conventions
- Read CONTEXT.md if present for domain glossary
- Follow existing conventions — do not add unnecessary scope or suggest refactoring unless directly relevant

### 2. Interview the developer

Focus on **technical direction**:
- How should this be implemented?
- Which packages/modules are affected?
- Are there existing patterns to follow or extend?
- What are the risks or unknowns?
- Are there testing implications? (Note repo-specific coverage requirements)
- Does this involve Sanity CMS? If so, prefer separate schema/content/UI tickets. If schema and UI are both required in one urgent bug/task, schema changes should be completed first so UI changes can use the generated schema types
- Does this need rollout planning, feature flags, backfills, content publishing coordination, or rollback notes? If not, record that a normal code merge is sufficient

**Only challenge requirements if:**
- They would cause significant technical debt
- They are overly complex for the stated goal
- There's a much simpler alternative

If requirements change during the interview, document the trade-offs prominently at the top of the PRD.

### 3. Flag scope issues

- If the ticket looks too large for a single PR, flag it and suggest splitting
- If CMS schema changes are bundled with UI work, strongly encourage separate tickets. If the developer confirms the work must stay together for a small bug/task, document the schema-first order and typegen implications

### 4. Write the PRD

Output the PRD to the Jira ticket's **Dev Notes** field. Do NOT overwrite the ticket summary or description — preserve the paper trail.

If Dev Notes already contains content, preserve it. Append the new PRD as a separate section or ask before replacing existing notes.

A `Technical PRD` Jira comment is **only** acceptable when:
1. The issue type does not support Dev Notes (e.g. Subtask), **or**
2. A Dev Notes write has been attempted in ADF format and the API returned an error.

Do not skip the ADF write attempt. Do not fall back to a comment because Dev Notes "looks unavailable", "is empty", or because markdown writes failed without trying ADF.

**PRD structure:**

```
## Technical Direction
[High-level implementation approach]

## Affected Modules
[Package/module level references. Include file paths only when they clarify ownership, route boundaries, schema definitions, test locations, or existing patterns]

## Acceptance Criteria Traceability
[Map ticket acceptance criteria to PRD considerations, e.g. AC-1, AC-2]

## Patterns to Follow
[Existing conventions or patterns in the codebase that should be used]

## Testing Strategy
[What needs testing, approach, coverage requirements for this repo]

## Rollout & Release
[Feature flags, migration/backfill needs, content publishing implications, rollback/reversibility, release dependencies. If none are needed, say so]

## Risks & Unknowns
[Technical risks, assumptions, open questions carried from the ticket]

## Out of Scope
[What this ticket explicitly does NOT cover]

## Trade-offs
[Only if requirements were challenged or changed — document what was discussed and why]
```

### 5. Update Jira

- Move the ticket to **In Progress** using transition ID `2` (Begin Work) from `capp-get-jira-info`. Confirm the ticket is in To Do before using this transition — if it's in a different status, consult the transition map in `capp-get-jira-info`. Assign to the developer (i.e. the current user — "me"); confirm identity if assignee lookup is ambiguous.
- Write the PRD to Dev Notes (`customfield_26991`) using `contentFormat: "adf"`. ADF is the required first attempt — do not skip it.
  - If the ADF write **succeeds**, you are done. Do not also post a comment.
  - If the ADF write **fails with an error**, you may then try `contentFormat: "markdown"` as a secondary attempt.
  - Only if both Dev Notes write attempts fail (or the issue type does not support Dev Notes at all) should you fall back to adding/updating a Jira comment titled `Technical PRD`. Record the underlying error in that comment so the developer can investigate.
- If Jira transitions or other fields fail unexpectedly, follow the fallback protocol in `capp-get-jira-info`. The Dev Notes-first rule above still applies — a comment is never the default destination for the PRD.

## Rules

- Prefer packages and modules over file paths, but include file paths when they clarify existing ownership, route boundaries, schema definitions, test locations, or patterns
- Do NOT add scope beyond what the ticket describes
- Do NOT suggest refactoring unless it's essential to deliver the ticket
- Keep the PRD concise — this is a working document, not a specification
- If the repo has CONTEXT.md, reference domain terms consistently
