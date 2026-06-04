---
name: capp-write-prd
description: CaPP workflow — write a concise technical PRD to a Jira ticket's Dev Notes (ADF-first; a Technical PRD comment only as a last-resort fallback). Invoke explicitly.
---

# CaPP Write PRD

Help a developer create a concise technical PRD (implementation approach, technical direction,
scope) for a Jira ticket they're about to work on.

**Step 2** of the CaPP workflow, after `capp-create-a-ticket`. Small, well-defined bugs may skip
straight to `capp-do-work`; standard features use this step.

**In:** Jira ticket key; its summary/description/acceptance criteria/comments/links; repo docs and
developer interview.
**Out:** a concise PRD written to the Jira **Dev Notes** field (`customfield_26991`). A
`Technical PRD` comment is a **last-resort fallback only** — see destination rules below.

## Preflight

1. Ask for the ticket key if not provided.
2. Run `capp-run-preflight-checks` for the ticket and target repo — this loads Jira metadata via
   `capp-get-jira-info` (Dev Notes field, Begin Work transition `2`, content formats).
3. Read the ticket (summary, description, AC, links, comments) — `responseContentFormat: "markdown"`.
4. Confirm the issue type supports Dev Notes (see availability in `capp-get-jira-info`). Dev Notes
   is the required target; only plan a comment fallback if the type genuinely doesn't support it
   (e.g. Subtask).
5. Don't ask the developer to re-describe the work — start from the ticket.

## Process

1. **Explore the codebase** — high-level structure/patterns, then deep-dive the affected areas.
   Read AGENTS.md (conventions) and CONTEXT.md (glossary). Follow existing conventions; don't add
   scope or suggest refactors unless directly relevant.
2. **Interview on technical direction** — how to implement; affected packages/modules; patterns to
   follow; risks/unknowns; testing implications (repo coverage requirements); Sanity involvement
   (CMS/schema splitting per `capp-conventions`); rollout needs (flags, backfills, publishing,
   rollback) — record if a normal merge suffices. Only challenge requirements that cause significant
   tech debt, are over-complex, or have a much simpler alternative; document any trade-offs at the
   top of the PRD.
3. **Flag scope issues** — too large for one PR → suggest splitting; CMS schema bundled with UI →
   push for separate tickets (or document schema-first order if confirmed together).
4. **Write the PRD** to Dev Notes. Don't overwrite summary/description. Preserve existing Dev Notes
   (append or ask before replacing).

**PRD structure:**

```
## Technical Direction
## Affected Modules            [packages/modules; file paths only where they clarify ownership, routes, schema, tests, or patterns]
## Acceptance Criteria Traceability   [map AC-1, AC-2 … to considerations]
## Patterns to Follow
## Testing Strategy            [what to test, approach, repo coverage requirements]
## Rollout & Release           [flags, migration/backfill, publishing, rollback, dependencies — or "none needed"]
## Risks & Unknowns
## Out of Scope
## Trade-offs                  [only if requirements were challenged/changed]
```

## Destination rules (Dev Notes first)

5. Move the ticket to **In Progress** (transition `2`, after confirming it's in To Do) and assign
   to the current user ("me"; confirm if ambiguous).
6. Write the PRD to Dev Notes (`customfield_26991`) with `contentFormat: "adf"` **first** — never
   skip this attempt.
   - ADF succeeds → done; do **not** also post a comment.
   - ADF errors → retry once with `contentFormat: "markdown"`.
   - Only if both Dev Notes attempts fail (or the type lacks Dev Notes) fall back to a comment
     titled `Technical PRD`, recording the underlying error.
   Do not choose the comment fallback because Dev Notes "looks unavailable" or "is empty".
   For other Jira failures, follow the fallback protocol in `capp-get-jira-info`.

## Rules

- Prefer packages/modules over file paths; include paths only where they clarify ownership, routes,
  schema, tests, or patterns.
- Do NOT add scope beyond the ticket or suggest non-essential refactors.
- Keep it concise — a working document, not a spec. Use CONTEXT.md domain terms if present.
