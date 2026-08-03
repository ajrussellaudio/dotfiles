# Issue tracker: Jira

Issues and specs (you may know a spec as a PRD) for this repo live as Jira issues. Use the
**Atlassian MCP** tools for all operations — there is no CLI. GitHub Issues are unavailable in this
repo, so never fall back to `gh issue ...`.

## Connection

Every Atlassian MCP call takes a `cloudId`. Read it, the project key, and the field/transition ids
from the **Instance settings** section at the bottom of this file. If a value isn't recorded there,
follow the [Discovery protocol](#discovery-protocol).

## Content format

The MCP defaults to ADF (Atlassian Document Format), so **always pass the format explicitly**:

- Writing (description, Dev Notes, comments, issue creation): `contentFormat: "markdown"`
- Reading: `responseContentFormat: "markdown"`

The one exception is the Dev Notes spec — see [Specs live in Dev Notes](#specs-live-in-dev-notes).

## Conventions

| Operation                | Atlassian MCP tool                                                                            |
| ------------------------ | --------------------------------------------------------------------------------------------- |
| **Create an issue**      | `createJiraIssue` with `projectKey`, `issueTypeName` (`Task` / `Bug` / `Story` / `Subtask`), `summary`, `description` |
| **Read an issue**        | `getJiraIssue` (pass `fields` to limit the payload; include `comment` for the discussion)        |
| **List / query issues**  | `searchJiraIssuesUsingJql` — JQL is the only query surface                                      |
| **Comment**              | `addCommentToJiraIssue`                                                                         |
| **Edit fields / labels** | `editJiraIssue` (labels are the `labels` array; assignee is `assignee`)                          |
| **Close**                | `transitionJiraIssue` — Jira closes via a **workflow transition**, not a delete/close verb       |
| **Link two issues**      | `createIssueLink` — pass the link **type name** (e.g. `"Blocks"`), not its id                    |
| **Who am I**             | `atlassianUserInfo` — needed to assign an issue to yourself                                     |

Two Jira facts that change how the skills behave:

- **Closing is a transition.** There is no "close with a comment" call. Post the comment first with
  `addCommentToJiraIssue`, then transition. Before using a hardcoded transition id, confirm the
  issue's **current status** matches the expected "from" status; if it doesn't, discover the correct
  transition live with `getTransitionsForJiraIssue`.
- **Issues are referenced by key, not number.** `CAPP-1234`, never `#1234`. When a skill's wording
  says `#42`, read it as an issue key.

## Triage labels

Jira has a native `labels` field — the canonical triage role strings from `triage-labels.md` go in
there, applied with `editJiraIssue`. Jira labels cannot contain spaces, which the canonical
hyphenated roles (`needs-triage`, `ready-for-agent`, …) already satisfy.

Note that Jira **status** and Jira **labels** are separate axes: the triage role is a label, and it
does not move the issue through the workflow. Don't transition an issue just because you labelled it.

## Pull requests as a triage surface

**PRs as a request surface: no.** Code review happens on GitHub PRs, but the tickets live in Jira, so
Jira has no external-contributor request surface to triage. Leave this off.

## When a skill says "publish to the issue tracker"

Create a Jira issue with `createJiraIssue` in the configured project. Default `issueTypeName` is
`Task`; use `Bug` for defects and `Story` only where story points are wanted.

## When a skill says "fetch the relevant ticket"

`getJiraIssue` with `responseContentFormat: "markdown"`, requesting the description, Dev Notes,
acceptance criteria, links and comments.

## Specs live in Dev Notes

When `/to-spec` (or any skill) publishes a **spec/PRD for an existing ticket**, write it to that
ticket's **Dev Notes** custom field rather than creating a second issue — the spec belongs to the
ticket it specifies.

Destination rules, in order:

1. Confirm the issue type supports Dev Notes (Subtask types generally do **not** — see Instance
   settings).
2. Write to Dev Notes with `contentFormat: "adf"` **first**. ADF renders correctly in the Jira UI;
   markdown in this field often renders as a wall of literal text.
3. If the ADF write errors, retry once with `contentFormat: "markdown"`.
4. Only if both Dev Notes attempts fail — or the issue type has no Dev Notes field — fall back to a
   `Technical PRD` comment. Do **not** choose the comment fallback merely because Dev Notes looks
   empty or "unavailable".
5. Never overwrite the summary or description, and preserve existing Dev Notes content unless the
   user asks for a replacement.

A spec for work that has **no** ticket yet creates a new issue as normal, then gets written into that
new issue's Dev Notes.

## Breaking a ticket into tickets

When `/to-tickets` breaks down an existing Jira ticket, publish each resulting ticket as a
**Subtask** of that parent (`issueTypeName: "Subtask"` with the parent key), so the hierarchy stays
visible in Jira. When there's no parent ticket, publish standalone `Task`s instead.

Publish in dependency order — blockers first — so each ticket's blocking edges can reference real
issue keys, then wire the edges in a second pass with `createIssueLink` (`type: "Blocks"`;
inward = the blocker, outward = the blocked ticket). Each subtask must reference the parent for
context and be self-contained enough to work from the subtask plus its parent.

## Wayfinding operations

Used by `/wayfinder`. The **map** is an Epic; its **child tickets** are `Task`s parented to it.

- **Map**: an `Epic` labelled `wayfinder:map`, holding the Destination / Notes / Decisions-so-far /
  Not-yet-specified body. Created with `createJiraIssue`. An Epic is used because Jira's native
  parent/child hierarchy gives the map real, UI-visible children.
- **Child ticket**: a `Task` whose parent is the map Epic, labelled `wayfinder:<type>`
  (`research` / `prototype` / `grilling` / `task`). `Task` — not `Subtask` — because children need
  the Dev Notes field and their own subtasks. Once claimed, the ticket is assigned to the driving
  dev.
- **Blocking**: Jira's **native issue links** — the canonical, UI-visible representation. Add an edge
  with `createIssueLink` passing `type: "Blocks"`, inward issue = the blocker, outward issue = the
  blocked ticket. A ticket is unblocked when every issue that blocks it has a `Done` status category.
- **Frontier query**: `searchJiraIssuesUsingJql` with
  `parent = <MAP-KEY> AND statusCategory != Done AND assignee IS EMPTY ORDER BY created ASC`, then
  read each candidate's `issuelinks` and drop any with an `is blocked by` link to an issue that isn't
  in the `Done` status category. First in map order wins. (JQL has no "has no open blockers"
  operator, so this filter is done client-side.)
- **Claim**: `editJiraIssue` setting `assignee` to your own account id from `atlassianUserInfo` — the
  session's first write.
- **Resolve**: `addCommentToJiraIssue` with the answer, then `transitionJiraIssue` to `Done`, then
  append a context pointer (gist + link) to the map's Decisions-so-far.

Because Jira has no cross-project issue numbering ambiguity, an issue key always resolves to exactly
one issue.

## Discovery protocol

If a recorded value errors, or you need one that isn't recorded below:

1. Try the recorded value first, if there is one.
2. Live-discover **once** — `getTransitionsForJiraIssue`, `getJiraProjectIssueTypesMetadata`,
   `getJiraIssueTypeMetaWithFields`, `getIssueLinkTypes`, `getVisibleJiraProjects`.
3. Continue if the result is unambiguous, and report the mismatch so this file can be updated.
4. If discovery is ambiguous or empty, ask the user — don't guess.

## Instance settings

_Record this repo's Jira instance here. The values below are the verified settings for Twinkl's CAPP
project; replace them if this repo tracks work elsewhere._

**Cloud id:** `3fa693cf-5995-4779-a4db-6af578c534d3` (`twinkl.atlassian.net`)
**Project:** key `CAPP`, id `14798` · _last verified 2025-07-16_

### Issue types

Pass `issueTypeName`; use the numeric id only where an API demands it.

| Type    | ID      | Subtask? |
| ------- | ------- | -------- |
| Task    | `21348` | No (default for general work) |
| Bug     | `21349` | No       |
| Story   | `21350` | No (only type carrying Story Points) |
| Epic    | `21351` | No       |
| Subtask | `21352` | Yes (under a parent issue) |

Other types (Spike, Unplanned Work, Design Task, Retro Action) exist — discover their ids live.

### Custom fields

| Field        | ID                   | Available on               |
| ------------ | -------------------- | -------------------------- |
| Dev Notes    | `customfield_26991`  | All types except **Subtask** |
| Story Points | `customfield_10016`  | Story only                 |
| Sprint       | `customfield_10020`  | Most types (dynamic — query live) |

### Transitions

Status → category: To Do → To Do · In Progress / In Review / In Test → In Progress ·
Ready for Release / Done → Done.

| From → To                 | Name       | ID  |
| ------------------------- | ---------- | --- |
| To Do → In Progress       | Begin Work | `2` |
| In Progress → In Review   | In Review  | `3` |
| In Progress / In Test → Done | Done    | `6` |

Other transitions (Failed Review/Testing, Won't Do, ReOpen) are discovery-only.

### Link types

| Name    | ID      | Inward / Outward          |
| ------- | ------- | ------------------------- |
| Blocks  | `10000` | is blocked by / blocks    |
| Relates | `10003` | relates to / relates to   |
