---
name: capp-address-pr-comments
description: Address all review comments on a GitHub pull request. Fixes code, pushes back with evidence, resolves threads after completion, and updates AGENTS.md only when specifically requested. Use after receiving PR review feedback.
---

# CaPP Address Review Comments

You are addressing review comments on a pull request. For each comment, either fix the issue or push back with evidence. Be thorough, professional, and assertive when you disagree.

## Workflow Position

This skill runs after **human review** (step 6) in the CaPP workflow. It can also address comments from `capp-self-review` if blocking issues were found.

## Inputs

Expect:
- PR number or URL
- Review threads, PR comments, and pending reviews
- Linked Jira ticket and acceptance criteria
- Repo docs and validation tiers from `capp-identify-repo-checks`

## Outputs

Produce:
- Code/documentation changes for accepted fixes
- Evidence-based replies for pushback or discussion
- Resolved threads only after replying and completing the requested change
- Validation summary using targeted and required local check tiers
- Updated AGENTS.md only when a reviewer specifically asks for a general rule/pattern to be documented

## Preflight

1. Identify the PR (ask if ambiguous)
2. Invoke `capp-get-jira-info` to load hardcoded CAPP Jira metadata (cloud ID, field IDs) for any Jira reads during this workflow
3. Run `capp-run-preflight-checks` in PR/comment-addressing mode
4. Fetch all review threads — unresolved comments, conversation comments, pending reviews
5. Read the PR diff, description, and linked Jira ticket for context. Use `responseContentFormat: "markdown"` when reading Jira fields
6. Use the `capp-identify-repo-checks` output from preflight as the validation plan

## Process

### 1. Classify each comment

For every review thread:

- **Fix required**: Clear code issue, bug, convention violation, or justified improvement
- **Push back**: The code is correct, the reviewer is mistaken, or the suggestion would make things worse
- **Discussion**: The reviewer is opening a conversation ("let's discuss", "what do you think about...") — provide context and suggestions but do NOT make code changes unless explicitly directed
- **AGENTS.md update**: The reviewer specifically asks for a general pattern or rule to be documented for future work

### 2. Address each comment

**For fixes:**
1. Make the code change
2. Run targeted checks on the affected package
3. Reply to the thread citing the commit or explaining the fix
4. Resolve the thread only after replying and completing the requested change

**For pushback:**
- Be assertive and cite evidence: documentation, codebase examples, test results, specifications
- Do NOT push back based on preference alone — only on facts
- If the reviewer is `@copilot` or an automated review bot: their opinion carries less weight only on subjective style or architectural preferences. Fully investigate correctness, security, accessibility, and CI-related findings regardless of source
- Reply to the thread with your reasoning

**For discussions:**
- Provide relevant context, examples from the codebase, and your recommendation
- Do NOT make code changes unless the reviewer explicitly asks for them
- Reply to the thread with your analysis

**For AGENTS.md updates:**
- Only update when the reviewer specifically asks for a general rule or pattern to be documented, not for PR-specific feedback
- General rules: "never use this pattern", "always prefer X over Y", "we don't do this in this repo"
- PR-specific feedback: "don't do this here", "in this case, try..."
- Add the update to AGENTS.md as part of the PR (so it's reviewed with the other changes)

### 3. Validation

Use staged validation to balance thoroughness with speed:
- After each small fix: targeted checks on the affected package
- After a batch of related fixes: broader checks on affected packages
- **Before push**: **CI should pass on the first push.** Run every check from `capp-identify-repo-checks` that can run locally — all required local checks (lint, typecheck, unit tests, format, build) plus all conditional checks relevant to the changed area (coverage, schema, bundle-size, etc.). Only skip CI-only checks that genuinely cannot run locally (secrets, external services, browsers); document which will run on push. Fix any failures before pushing

### 4. CONTEXT.md

If CONTEXT.md exists and changes introduced new terms, patterns, or changed domain concepts, update it.

### 5. Thread tracking

After addressing all comments, report:
- How many threads were fixed
- How many threads were pushed back on
- How many threads are still unresolved (and why)
- Any AGENTS.md changes made

### 6. Re-run self-review?

Only if changes were substantial:
- More than 3 files changed
- Significant logic changes
- Auth, security, or data-fetching code modified
- Sanity schema or query changes
- Reviewer requested architectural changes

If a re-run is warranted, run `capp-self-review` after pushing.

## Rules

- Do NOT fix issues in unrelated areas of the code
- Do NOT make code changes for "discussion" comments unless explicitly directed
- Do NOT delete or dismiss comments — always reply
- Do NOT make destructive Jira changes
- Always cite evidence when pushing back — documentation, codebase examples, test results
- If AGENTS.md is updated, include it in the PR for human review
