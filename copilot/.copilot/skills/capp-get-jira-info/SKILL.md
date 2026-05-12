---
name: capp-get-jira-info
description: >
  Centralised CAPP Jira metadata — cloud ID, field IDs, transition IDs,
  issue type IDs, link types. Invoke before any Jira MCP call to skip
  redundant discovery API calls and ensure consistent field references.
---

# CaPP Jira Reference Data

> **Scope:** This metadata applies only to the **CAPP** project on Andy Berry's
> Atlassian Cloud instance. Do not assume these IDs are valid for other projects
> or tenants.
>
> **Last verified:** 2025-07-16

## Stability Classification

| Level | Meaning | Examples |
|-------|---------|----------|
| **Stable** | Changes only via admin action; safe to hardcode | Cloud ID, project ID/key, field IDs, issue type IDs, link type IDs |
| **Workflow-dependent** | Changes if the Jira workflow is edited | Transition IDs, status IDs, status category mappings |
| **Dynamic** | Changes frequently; always query live | Sprint IDs, user account IDs, board IDs |

---

## Connection

| Key | Value |
|-----|-------|
| Cloud ID | `3fa693cf-5995-4779-a4db-6af578c534d3` |
| Project key | `CAPP` |
| Project ID | `14798` |

Pass `cloudId: "3fa693cf-5995-4779-a4db-6af578c534d3"` to every Atlassian MCP tool call.

---

## Issue Types

| Type | ID | Subtask? | Notes |
|------|----|----------|-------|
| Task | `21348` | No | Default for general work |
| Bug | `21349` | No | |
| Story | `21350` | No | Only type with Story Points |
| Epic | `21351` | No | |
| Subtask | `21352` | Yes | Created under a parent issue |
| Spike | `25025` | No | |
| Unplanned Work | `25026` | No | |
| Design Task | `30779` | No | |
| Retro Action | `32181` | No | |

When creating issues pass `issueTypeName` (e.g. `"Task"`) — the MCP tool resolves the name. Use the numeric ID only when an API requires it explicitly.

---

## Custom Fields

| Field | ID | Available on | Format notes |
|-------|----|-------------|--------------|
| Dev Notes | `customfield_26991` | Task, Bug, Story, Epic, Spike, Unplanned Work, Design Task — **NOT Subtask** | Rich text. Write with `contentFormat: "markdown"`. Read with `responseContentFormat: "markdown"` |
| Story Points | `customfield_10016` | Story only | Number |
| Sprint | `customfield_10020` | Most types | Dynamic — always query live |
| Flagged | `customfield_10021` | Most types | Option ID `10019` = Impediment |

### Field Availability Matrix

| Field | Task | Bug | Story | Subtask | Epic | Spike |
|-------|------|-----|-------|---------|------|-------|
| Dev Notes | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Story Points | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Sprint | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |

---

## Workflow & Transitions

### Status Map

| Status | Category |
|--------|----------|
| To Do | To Do |
| In Progress | In Progress |
| In Review | In Progress |
| In Test | In Progress |
| Ready for Release | Done |
| Done | Done |

### Transition Map

| From → To | Transition Name | ID |
|-----------|----------------|-----|
| To Do → In Progress | Begin Work | `2` |
| In Progress → In Review | In Review | `3` |
| In Review → In Test | In Test | `4` |
| In Test → Ready for Release | Ready for Release | `5` |
| In Progress → Done | Done | `6` |
| In Test → Done | Done | `6` |
| In Test → In Progress | Failed Testing | `7` |
| In Review → In Progress | Failed Review | `8` |
| Any → Won't Do | Won't Do | `10` |
| In Progress → To Do | ToDo | `11` |
| Done → To Do | ReOpen | `12` |
| Done → In Progress | In Progress | `14` |

### Transition Validation Rule

**Always confirm the issue's current status matches the expected "From" status before using a hardcoded transition ID.** Jira transition IDs are only valid from specific statuses. If the current status does not match, consult this map to find the correct transition or fall back to live discovery.

---

## Link Types

| Name | ID | Inward description | Outward description |
|------|-----|-------------------|---------------------|
| Blocks | `10000` | is blocked by | blocks |
| Cloners | `10001` | is cloned by | clones |
| Duplicate | `10002` | is duplicated by | duplicates |
| Relates | `10003` | relates to | relates to |

When creating links with `createIssueLink`, pass the **name** (e.g. `type: "Blocks"`). The inward issue is the blocker; the outward issue is the blocked task.

---

## Content Format Guidance

| Operation | Parameter | Value |
|-----------|-----------|-------|
| Writing description / Dev Notes / comments | `contentFormat` | `"markdown"` |
| Reading issue fields | `responseContentFormat` | `"markdown"` |
| Creating issues | `contentFormat` | `"markdown"` |

Always pass these parameters explicitly — the MCP default is ADF, which is harder to read and write.

---

## Fallback Protocol

If a hardcoded value fails (e.g. transition returns an error, field is not found):

1. **Try hardcoded value** from this skill first
2. **Live discovery once** — query the relevant Jira metadata endpoint (transitions, fields, issue types)
3. **Continue if unambiguous** — if discovery returns the expected value under a different ID, use it and report the mismatch
4. **Report mismatch** — note the discrepancy so this skill can be updated
5. **Ask the user if ambiguous** — if discovery returns multiple candidates or no match, do not guess

This protocol avoids both blind trust in stale IDs and unnecessary API calls on every invocation.

---

## Dynamic Values (Always Query Live)

These values change too frequently to hardcode:

- **Sprint ID** — query via `customfield_10020` on an existing issue, or list sprints from the board
- **User account IDs** — use `lookupJiraAccountId` with search string
- **Board ID** — query if needed for sprint operations
- **Epic link** — varies by Jira configuration; check field metadata if linking to epics

---

## How Skills Should Use This Data

1. **Invoke this skill** at the start of any workflow that calls Atlassian MCP tools
2. **Use hardcoded values directly** for stable and workflow-dependent fields — do not re-discover cloud ID, project ID, field IDs, transition IDs, or link types on every run
3. **Follow the transition validation rule** — check current status before using a transition ID
4. **Follow the fallback protocol** if any hardcoded value produces an error
5. **Always pass `contentFormat`/`responseContentFormat`** as specified in the content format table
6. **Check the field availability matrix** before writing to Dev Notes or Story Points — these are not available on all issue types
