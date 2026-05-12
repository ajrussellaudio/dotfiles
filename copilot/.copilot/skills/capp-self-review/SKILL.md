---
name: capp-self-review
description: Review a pull request as an independent reviewer. Shows findings privately before posting to GitHub. Checks code quality, conventions, security, accessibility practices, and PR completeness. Use after implementation is complete.
---

# CaPP Self Review

You are performing an independent code review of a pull request. You are NOT the author of this code — review it critically and objectively as if you are a senior developer on the team.

## Workflow Position

This is the **fifth step** in the CaPP development workflow, after `capp-do-work`. After the private findings have been shown to the developer, the PR can be marked ready for human review if there are no blocking issues and the developer approves the posted output.

## Inputs

Expect:
- PR number or URL
- Linked Jira ticket
- Repo docs and PR template
- Check tiers and validation summary from implementation, where available

## Outputs

Return a private review summary first. After the developer has seen the findings and approved what should be posted, optionally post GitHub review comments/summary, mark the PR ready, and move the parent Jira ticket to `Review` if appropriate.

## Preflight

1. Identify the PR to review:
   - If just finished `capp-do-work`, use that PR
   - Otherwise, ask which PR to review (by number or URL)
   - If ambiguous (e.g. multiple open PRs), ask the developer to confirm
2. Invoke `capp-get-jira-info` to load hardcoded CAPP Jira metadata — in particular, In Review transition ID (`3`)
3. Read the PR: diff, description, linked Jira ticket. Use `responseContentFormat: "markdown"` when reading Jira fields
4. Run `capp-run-preflight-checks` in PR/review mode
4. Read AGENTS.md if present for repo conventions
5. Read CONTEXT.md if present for domain glossary

## Review Process

Use a **separate agent** for the review where available — do not review your own work. If sub-agents are not available, perform an equivalent separate-pass review.

### 1. Code Quality

- **Correctness**: Does the code do what the ticket/PRD asks?
- **Edge cases**: Are boundary conditions handled?
- **Error handling**: Are errors handled appropriately for this repo/framework? Avoid swallowed errors and broad catch/fallback patterns
- **Type safety**: Are types precise? No `any`, no unnecessary type assertions?
- **Naming**: Are names clear and consistent with codebase conventions?
- **Duplication**: Is there unnecessary duplication? Could existing utilities be reused?

### 2. Conventions & Patterns

- Does the code follow patterns established in AGENTS.md?
- Does it match existing code style in the affected packages?
- Are imports and exports structured correctly?
- Are design system tokens used instead of raw values (e.g. `p-400` not `p-4`)?
- Are CSS logical properties used for RTL support (`ms-`/`me-` not `ml-`/`mr-`)?

### 3. Testing

- Are new behaviours covered by tests?
- Do tests verify outcomes, not implementation details?
- Are real components preferred over mocks?
- Is coverage adequate for the repo's requirements?

### 4. Security & Accessibility

- No hardcoded secrets, keys, or credentials
- No XSS vectors in user-facing output
- Good semantic HTML practices (appropriate elements, ARIA attributes where needed)
- Data attributes for testing and tracking where appropriate

### 5. PR Completeness

- Is the PR description accurate and complete?
- Is the Jira ticket linked?
- Does the description follow the repo PR template and documented repo conventions?
- Does the PR description trace acceptance criteria where applicable?
- If CONTEXT.md exists, has it been updated with new terms or patterns?

## Output

### Severity Levels

- 🔴 **Critical** `[blocking]` — Must fix before merge. Bugs, security issues, data loss risks, broken functionality
- 🟡 **Warning** `[non-blocking]` — Should fix. Convention violations, missing edge cases, weak tests
- 🔵 **Suggestion** `[suggestion]` — Consider improving. Better patterns, naming, clarity
- 🟢 **Highlights** — Key decisions, good patterns, noteworthy approaches (only genuinely notable things, not filler praise)

### Private-first output

Show the findings to the developer in the terminal before posting anything to GitHub. The developer may remove, add, or edit findings before they are posted.

### GitHub Comments

Only post to GitHub after the developer approves the review output.

**Inline comments**: Post on specific lines for 🔴 and 🟡 findings that the developer approves for posting. Include the severity label (e.g. `[blocking]`, `[non-blocking]`).

**Summary comment**: Post a single summary comment on the PR with:
- Overview of the review
- Count of findings by severity
- List of all findings with file and line references
- Highlights section
- Recommended next action (e.g. "3 blocking issues — address before review" or "No blocking issues — ready for human review if approved")

### Terminal output

Return the summary to the developer first.

## Post-Review Actions

- If **no 🔴 findings** and the developer approves: Mark the PR as **ready for review** (remove draft status). Move the parent Jira ticket to **In Review** using transition ID `3` from `capp-get-jira-info`. Confirm the ticket is in In Progress before using this transition
- If **🔴 findings exist**: Keep the PR as draft. Summarise what needs fixing. The developer can run `capp-address-pr-comments` or fix manually
- Do not move the parent Jira task past **Review**

## Rules

- Use a **separate agent** for the review where available — independence matters
- Do NOT auto-fix issues — document them. Fixes are the developer's or `capp-address-pr-comments`'s job
- Do NOT comment on commit history — PRs are squash-merged
- Do NOT review generated files or lockfiles except to check they were regenerated through the correct tool/package manager
- Keep comments actionable — every comment should have a clear "do this" or "consider this"
