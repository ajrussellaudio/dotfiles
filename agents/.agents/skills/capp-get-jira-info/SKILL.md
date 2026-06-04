---
name: capp-get-jira-info
description: Centralised CAPP Jira metadata — cloud ID, field/transition/issue-type/link IDs. Internal; load before Jira MCP calls in capp-* skills. Anything not listed here, discover live.
---

# CaPP Jira Reference Data

> **Scope:** the **CAPP** project on Twinkl's Atlassian Cloud only (`twinkl.atlassian.net`). **Last verified:** 2025-07-16.
> This lists the values the CaPP skills actually use; for anything else, follow the fallback protocol
> (discover live once).

**Connection:** pass `cloudId: "3fa693cf-5995-4779-a4db-6af578c534d3"` to every Atlassian MCP call.
Project key `CAPP`, project ID `14798`.

## Issue Types

Pass `issueTypeName` (e.g. `"Task"`); use the numeric ID only when an API demands it.

| Type | ID | Subtask? |
|------|----|----------|
| Task | `21348` | No (default for general work) |
| Bug | `21349` | No |
| Story | `21350` | No (only type with Story Points) |
| Epic | `21351` | No |
| Subtask | `21352` | Yes (under a parent issue) |

Other types (Spike, Unplanned Work, Design Task, Retro Action) exist — discover their IDs live if
needed.

## Custom Fields

| Field | ID | Available on |
|-------|----|-------------|
| Dev Notes | `customfield_26991` | All except **Subtask** |
| Story Points | `customfield_10016` | Story only |
| Sprint | `customfield_10020` | Most types (dynamic — query live) |

## Transitions (the ones skills use)

Statuses → category: To Do→To Do · In Progress / In Review / In Test→In Progress ·
Ready for Release / Done→Done.

| From → To | Name | ID |
|-----------|------|-----|
| To Do → In Progress | Begin Work | `2` |
| In Progress → In Review | In Review | `3` |
| In Progress / In Test → Done | Done | `6` |

**Validation rule:** confirm the issue's current status matches the expected "From" before using a
hardcoded ID; if it doesn't match, discover the correct transition live. Other transitions (Failed
Review/Testing, Won't Do, ReOpen, etc.) are discovery-only.

## Link Types

Pass the **name** to `createIssueLink`; inward = blocker, outward = blocked.

| Name | ID | Inward / Outward |
|------|-----|------------------|
| Blocks | `10000` | is blocked by / blocks |
| Relates | `10003` | relates to / relates to |

## Content Format

MCP defaults to ADF, so pass explicitly: `contentFormat: "markdown"` when writing
(description / Dev Notes / comments / creating issues); `responseContentFormat: "markdown"` when
reading. (capp-write-prd has its own ADF-first rule for Dev Notes.)

## Fallback Protocol

If a hardcoded value errors, or you need a value not listed above:
1. Try the hardcoded value first (if listed).
2. Live-discover **once** (transitions / fields / issue types / links).
3. Continue if unambiguous; report any mismatch so this skill can be updated.
4. If discovery is ambiguous or empty, ask the user — don't guess.
