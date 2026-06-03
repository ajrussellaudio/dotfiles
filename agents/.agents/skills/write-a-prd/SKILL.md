---
name: write-a-prd
description: Create a PRD through user interview, codebase exploration, and module design, then submit as a GitHub issue, GitHub Projects board, or JIRA ticket. Use when user wants to write a PRD, create a product requirements document, or plan a new feature.
---

This skill will be invoked when the user wants to create a PRD. You may skip steps if you don't consider them necessary.

1. Ask the user for a long, detailed description of the problem they want to solve and any potential ideas for solutions.

2. Explore the repo to verify their assertions and understand the current state of the codebase.

3. Interview the user relentlessly about every aspect of this plan until you reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

4. Sketch out the major modules you will need to build or modify to complete the implementation. Actively look for opportunities to extract deep modules that can be tested in isolation.

A deep module (as opposed to a shallow module) is one which encapsulates a lot of functionality in a simple, testable interface which rarely changes.

Check with the user that these modules match their expectations. Check with the user which modules they want tests written for.

5. Once you have a complete understanding of the problem and solution, use the template below to write the PRD.

6. Ask the user which backend to use for the PRD:

- **GitHub Issues** — for repos with Issues enabled
- **GitHub Projects** — for repos with Issues disabled
- **JIRA (new ticket)** — for work projects with a fresh ticket on a board
- **JIRA (existing ticket Dev Notes)** — append PRD to an existing ticket's Dev Notes field

### Option A: GitHub Issues

Ask the user for a short, lowercase, hyphenated slug for this feature (e.g. `foo-widget`). This will be used to name the GitHub label and feature branch.

The PRD should be submitted as a GitHub issue with two labels:
- `prd` — marks this as a PRD issue that must never be implemented directly
- `prd/<slug>` — scopes this PRD and all its task issues to a feature branch (`feat/<slug>`)

Create the labels if they don't exist yet:
```bash
gh label create "prd" --color "5319E7" 2>/dev/null || true
gh label create "prd/<slug>" --color "0075ca" 2>/dev/null || true
```

Then create the issue:
```bash
gh issue create --title "PRD: <title>" --body "..." --label "prd" --label "prd/<slug>"
```

After creating the issue, tell the user they can break it into tasks with `/prd-to-issues`.

Also tell the user to start Ralph with `ralph run --label=<slug>`.

### Option B: GitHub Projects

For repos where GitHub Issues are disabled. The PRD is stored as the description of a new GitHub Projects V2 board.

Ask the user for a short, lowercase, hyphenated slug for this feature (e.g. `foo-widget`). This is used as the project board title and feature branch suffix.

First, get the user's GitHub user ID:
```bash
gh api graphql -f query='{ viewer { id } }' --jq '.data.viewer.id'
```

Create a Project board named after the slug:
```bash
gh api graphql -f query='
mutation {
  createProjectV2(input: {ownerId: "<USER_ID>", title: "<slug>"}) {
    projectV2 { id url number }
  }
}'
```

Then set the PRD text as the board's short description (max 256 chars — use the Problem Statement summary):
```bash
gh api graphql -f query='
mutation {
  updateProjectV2(input: {projectId: "<PROJECT_ID>", shortDescription: "<summary>"}) {
    projectV2 { id }
  }
}'
```

Also post the full PRD as a pinned draft item titled "PRD: <title>" so the complete text is accessible on the board:
```bash
gh api graphql -f query='
mutation {
  addProjectV2DraftIssue(input: {projectId: "<PROJECT_ID>", title: "PRD: <title>", body: "<full PRD text>"}) {
    projectItem { id }
  }
}'
```

Print the board URL and tell the user they can break it into tasks with `/prd-to-project`.

**Note:** The `gh` token must have the `project` scope. If the GraphQL call fails with `INSUFFICIENT_SCOPES`, tell the user to run `gh auth refresh -s project`.

### Option C: JIRA (new ticket)

For work projects backed by JIRA. The PRD is stored as the description of a new parent ticket on a JIRA board. Sub-tasks of this ticket will become Ralph's task units.

Use the Atlassian MCP tools (prefixed `atlassian-rovo-mcp-`) — not jira-cli — for skill operations.

1. Ask the user for the JIRA project key (e.g. `CAPP`, `PROJ`). This is the prefix that appears in ticket IDs like `CAPP-123`.

2. Resolve the cloudId. Try the user's site hostname first, or call `getAccessibleAtlassianResources` if unknown.

3. Confirm the issue type to use for the parent. Default to `Story` unless the user specifies otherwise (e.g. `Epic`, `Task`). Ralph treats whichever type the user picks as the "parent ticket" — issue type only matters for sub-task branch prefix, not the parent.

4. Create the parent ticket with `createJiraIssue`:
   - `projectKey`: the project key
   - `issueTypeName`: from step 3
   - `summary`: `PRD: <title>`
   - `description`: full PRD body (use `contentFormat: "markdown"`)

5. Print the ticket key and URL. Tell the user they can break it into sub-tasks with `/prd-to-subtasks`.

### Option D: JIRA (existing ticket Dev Notes)

For when the user has already created a JIRA ticket and wants to attach the PRD to it. The PRD is appended to a custom field called **Dev Notes** on the ticket.

1. Ask the user for the ticket key (e.g. `CAPP-123`).

2. Resolve the cloudId (as above).

3. Find the Dev Notes custom field ID for this project — Dev Notes is a custom field, so its ID is `customfield_NNNNN`. Use `getJiraIssueTypeMetaWithFields` against the ticket's project and issue type, find the field whose name is `Dev Notes`, and note its `customfield_*` key. If there are multiple matches or none, ask the user to confirm.

4. Fetch the current ticket with `getJiraIssue` so you have the existing Dev Notes content (don't overwrite it).

5. Update the ticket with `editJiraIssue`, setting the Dev Notes field to the existing content followed by the full PRD body. Use a clear separator like `\n\n---\n\n# PRD: <title>\n\n...` between the prior content and the new PRD so it's obvious where the PRD starts.

6. Print the ticket key and URL. Tell the user they can break it into sub-tasks with `/prd-to-subtasks`.

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>
