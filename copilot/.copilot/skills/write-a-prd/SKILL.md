---
name: write-a-prd
description: Create a PRD through user interview, codebase exploration, and module design, then submit as a GitHub issue or GitHub Projects board. Use when user wants to write a PRD, create a product requirements document, or plan a new feature.
---

This skill will be invoked when the user wants to create a PRD. You may skip steps if you don't consider them necessary.

1. Ask the user for a long, detailed description of the problem they want to solve and any potential ideas for solutions.

2. Explore the repo to verify their assertions and understand the current state of the codebase.

3. Interview the user relentlessly about every aspect of this plan until you reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

4. Sketch out the major modules you will need to build or modify to complete the implementation. Actively look for opportunities to extract deep modules that can be tested in isolation.

A deep module (as opposed to a shallow module) is one which encapsulates a lot of functionality in a simple, testable interface which rarely changes.

Check with the user that these modules match their expectations. Check with the user which modules they want tests written for.

5. Once you have a complete understanding of the problem and solution, use the template below to write the PRD.

Ask the user for a short, lowercase, hyphenated slug for this feature (e.g. `foo-widget`). This will be used to name the GitHub label and feature branch.

6. Ask the user which backend to use for the PRD:

### Option A: GitHub Issues

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

### Option B: GitHub Projects

For repos where GitHub Issues are disabled. The PRD is stored as the description of a new GitHub Projects V2 board.

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
