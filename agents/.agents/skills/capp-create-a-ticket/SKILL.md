---
name: capp-create-a-ticket
description: Create well-structured Jira tickets through adaptive interview. Captures goals, constraints, and acceptance criteria without prescribing implementation. Use when creating new work items for the CaPP team.
---

# CaPP Create Ticket

You are helping an Engineering Manager or Product Manager create a well-structured Jira ticket. Your goal is to capture the right level of detail — enough context for a developer to understand and pick up the work, without prescribing implementation.

## Workflow Position

This is the **first step** in the CaPP development workflow. The ticket may sit for days or weeks before a developer picks it up, so do not reference next steps or downstream skills.

For small bugs or tasks, the lightweight workflow may be `capp-create-a-ticket` -> `capp-do-work` -> `capp-self-review`. Standard feature work should continue through PRD and subtask planning.

## Inputs

Expect a user request, bug report, feature idea, or rough work description. The user may also provide links to designs, Confluence pages, existing tickets, customer reports, or affected systems.

## Outputs

Create one or more Jira tickets with:
- Clear problem statement and affected users
- Acceptance criteria
- CMS/content impact
- Constraints, dependencies, and open questions
- Links to relevant context
- Appropriate Jira project, issue type, priority, sprint, and links where available

## Process

### 1. Understand the request

Ask the user what they need. Adapt your interview style:
- **Simple/clear requests**: Batch related questions, keep it brief
- **Complex/ambiguous requests**: Deep interview, resolve one branch at a time

### 2. Interview

Gather the following through conversation:

**Required:**
- Problem statement — what needs to change and why
- Acceptance criteria — measurable definition of done
- Affected users / audience
- Priority indication

**Prompt for (don't demand):**
- Technical context — capture what the requester knows without requiring deep technical knowledge
- Constraints — deadlines, dependencies, limitations
- Links — Confluence pages, Figma designs, related tickets. If mentioned, include them prominently
- CMS impact — does this involve Sanity CMS schema or content changes?
- Epic — ask if this ticket belongs to an epic. The user may provide an epic key (e.g. `CAPP-387`) or an epic name (e.g. "CMS BAU")
- Sprint — ask if this should be added to the active sprint

**Watch for:**
- **CMS + UI scope** — strongly encourage separating CMS schema changes from UI/code changes into separate tickets. Prompt if the request seems to span both
- **Large scope** — if the request is too large for a single ticket, suggest splitting and linking with "depends on" / "relates to" relationships

### 3. Create the ticket

**Before creating any Jira issues**, invoke `capp-get-jira-info` to load hardcoded CAPP Jira metadata (cloud ID, project key/ID, issue type IDs, link types). Use these values directly instead of discovering them via API.

**Project:** Default to CAPP (project ID `14798`). Ask if a different project is needed.

**Ticket structure:**

```
## TL;DR
[One-line summary of the change]

## Design Links
[Figma links, mockups — if any were mentioned]

## Links
[Confluence pages, related tickets, external references]

## Problem
[What needs to change and why]

## Acceptance Criteria
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]

## Affected Users
[Who is impacted by this change]

## CMS Impact
[Does this involve Sanity CMS? Schema changes? Content changes? "None" if not applicable]

## Constraints
[Deadlines, dependencies, technical limitations, out of scope items]

## Open Questions
[Unresolved details or assumptions that the developer should be aware of]
```

### 4. Scope splitting

If the work should be multiple tickets:
1. Create each ticket with the structure above
2. Link them appropriately:
   - "depends on" for sequential dependencies
   - "relates to" for parallel/related work
3. Clearly state which ticket should be picked up first

### 5. Sprint

If the user confirms the ticket should be in a sprint:
1. Discover the active CAPP sprint.
2. If exactly one active CAPP sprint is available, use it.
3. If multiple active sprints are available, or discovery fails, ask for the sprint name/ID.
4. If the developer is unavailable or the sprint cannot be identified, leave the ticket in the backlog and state why.

Otherwise leave it in the backlog.

### 6. Epic

Ask whether the ticket should belong to an epic. The user may provide either an epic key (e.g. `CAPP-387`) or an epic name (e.g. "CMS BAU").

**If the user provides an epic key:**
1. Fetch the issue and confirm it exists, is an Epic, and belongs to the intended project (unless the user explicitly wants a cross-project epic).
2. If the issue is not found, is not an Epic, or is in an unexpected project, ask for clarification.

**If the user provides an epic name:**
1. Search for matching epics in the selected project using JQL, escaping user input:
   `project = <projectKey> AND issuetype = Epic AND summary ~ "<epic name>"`
2. Prefer active epics — deprioritise Done/Closed epics.
3. If exactly one suitable epic matches, use it.
4. If multiple match, ask the user to pick — show key, summary, and status for each.
5. If none match, ask for clarification or an epic key.

**Assigning the epic:**

Assign the ticket to the epic using Jira hierarchy metadata — do NOT use issue links (Relates, Blocks, etc.) for epic membership.

- Use the `parent` field when creating the issue.
- If `parent` is unavailable or rejected, inspect Jira field metadata for the Epic Link custom field and use that instead.
- If the epic cannot be set through available Jira tools, create the ticket and add a Jira comment preserving the intended epic (e.g. "Intended epic: CAPP-387 — CMS BAU"). Report this to the user.

**Scope splitting:** If the request is split into multiple tickets, ask whether the selected epic applies to all tickets or only specific ones.

## Jira capability handling

CaPP Jira is expected to support this workflow. Use values from `capp-get-jira-info` (cloud ID, issue type IDs, link types, field IDs) to skip redundant discovery calls. Always pass `contentFormat: "markdown"` when writing description content.

If a field, issue type, priority, sprint, or link operation fails, follow the fallback protocol in `capp-get-jira-info` — perform live discovery once, continue if unambiguous, and report the mismatch. If the developer is unavailable and context would otherwise be lost, add a Jira comment with the information instead of overwriting the description.

## Rules

- Do NOT overwrite or delete existing ticket content
- Do NOT mention downstream workflow steps — the ticket stands alone
- Use the Jira CAPP project by default, confirm if the user mentions a different project
- If Confluence pages or Figma designs are mentioned during the conversation, add them to the appropriate section
- Keep language clear and jargon-free — tickets are read by developers, QA, and stakeholders
