---
name: capp-create-a-ticket
description: CaPP — create well-structured Jira tickets via adaptive interview, capturing goals/constraints/AC without prescribing implementation. Use for CaPP/Jira ticket creation.
---

# CaPP Create Ticket

Help an EM/PM create a well-structured Jira ticket — enough context for a developer to pick up the
work, without prescribing implementation.

**Step 1** of the CaPP workflow. The ticket may sit for weeks before pickup, so do **not** reference
downstream skills/steps. (Small bugs: create → `capp-do-work` → `capp-self-review`; features
continue through PRD and subtask planning.)

**In:** a request, bug report, feature idea, or rough description, plus any links (designs,
Confluence, tickets).
**Out:** one or more Jira tickets with problem statement, acceptance criteria, CMS/content impact,
constraints/dependencies/open questions, links, and correct project/issue type/priority/sprint/epic.

## Process

### 1. Understand & interview

Adapt style: batch questions for simple requests; deep one-branch-at-a-time interview for complex
ones. Gather:

- **Required:** problem statement (what + why), acceptance criteria (measurable), affected
  users/audience, priority indication.
- **Prompt for (don't demand):** technical context the requester knows; constraints
  (deadlines, dependencies); links (include prominently if mentioned); CMS impact (Sanity schema or
  content?); epic (key e.g. `CAPP-387` or name e.g. "CMS BAU"); sprint (active sprint?).
- **Watch for:** CMS + UI scope → encourage splitting schema from UI into separate tickets (per
  `capp-conventions`). Large scope → suggest splitting, linked with "depends on" / "relates to".

### 2. Create the ticket

First invoke `capp-get-jira-info` for metadata (cloud ID, project, issue type IDs, link types) and
use it directly. Default project CAPP (`14798`); ask if different. Write with
`contentFormat: "markdown"`.

```
## TL;DR
[One-line summary]

## Design Links
[Figma/mockups — if mentioned]

## Links
[Confluence, related tickets, external refs]

## Problem
[What needs to change and why]

## Acceptance Criteria
- [ ] [Measurable outcome]

## Affected Users
[Who is impacted]

## CMS Impact
[Sanity schema/content changes? "None" if N/A]

## Constraints
[Deadlines, dependencies, limitations, out of scope]

## Open Questions
[Unresolved details / assumptions]
```

### 3. Scope splitting

If multiple tickets: create each with the structure above, link ("depends on" sequential /
"relates to" parallel), and state which to pick up first.

### 4. Sprint

If a sprint is wanted: discover the active CAPP sprint; use it if exactly one; if multiple or
discovery fails, ask. If unresolved, leave in backlog and say why. Otherwise backlog.

### 5. Epic

User gives an epic key or name.
- **Key:** fetch and confirm it exists, is an Epic, and is in the intended project (unless a
  cross-project epic is explicitly wanted); otherwise ask.
- **Name:** search with JQL (escape input):
  `project = <key> AND issuetype = Epic AND summary ~ "<name>"`. Prefer active epics. One match →
  use it; multiple → ask (show key, summary, status); none → ask for clarification/key.
- **Assign via Jira hierarchy, not issue links:** use the `parent` field on create; if rejected,
  use the Epic Link custom field from field metadata; if neither works, create the ticket and add a
  comment recording the intended epic, and report it.
- If split into multiple tickets, ask whether the epic applies to all or some.

## Jira capability & fallback

Use `capp-get-jira-info` values to skip discovery. If any field/issue-type/priority/sprint/link
operation fails, follow its fallback protocol (discover once, continue if unambiguous, report
mismatch). If the developer is unavailable and context would be lost, add a comment rather than
overwriting the description.

## Rules

- Do NOT overwrite/delete existing ticket content, or mention downstream workflow steps.
- Default to CAPP; confirm if another project is mentioned.
- Add any mentioned Confluence/Figma links to the right section.
- Keep language clear and jargon-free — read by devs, QA, and stakeholders.
