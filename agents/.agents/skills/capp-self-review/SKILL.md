---
name: capp-self-review
description: CaPP workflow — independent PR review, shown privately before optionally posting to GitHub (code quality, conventions, security, a11y, completeness). Invoke explicitly.
---

# CaPP Self Review

Review a PR critically and objectively, as a senior teammate who is **not** the author.

**Step 5** of the CaPP workflow, after `capp-do-work`. Once private findings are shared and the
developer approves, the PR can be marked ready for human review if there are no blockers.

**In:** PR number/URL; linked ticket; repo docs and PR template; validation summary from
implementation.
**Out:** a **private** review summary first; after approval, optionally GitHub comments/summary,
mark the PR ready, and move the parent ticket to In Review.

## Preflight

1. Identify the PR (the one from `capp-do-work`, else ask; confirm if multiple open).
2. Run `capp-run-preflight-checks` in PR/review mode — this loads Jira metadata via
   `capp-get-jira-info` (In Review transition `3`).
3. Read the PR (diff, description, linked ticket — `responseContentFormat: "markdown"`), AGENTS.md
   (conventions), CONTEXT.md (glossary).

## Review

Review independently per `capp-conventions` (separate agent where available) — don't review your own
work. Cover:

- **Code quality:** correctness vs ticket/PRD; edge cases; error handling (no swallowed errors or
  broad catch/fallback); type safety (no `any`/needless assertions); clear naming; no needless
  duplication (reuse utilities).
- **Conventions:** AGENTS.md patterns; matches existing style; correct imports/exports; design
  tokens not raw values (`p-400` not `p-4`); CSS logical properties for RTL (`ms-`/`me-` not
  `ml-`/`mr-`).
- **Testing:** new behaviour covered; tests verify outcomes not implementation; real components
  over mocks; coverage adequate for the repo.
- **Security & a11y:** no hardcoded secrets; no XSS in user-facing output; semantic HTML / ARIA;
  data attributes for testing/tracking where appropriate.
- **PR completeness:** accurate description following the repo template; ticket linked; AC traced;
  CONTEXT.md updated if new terms/patterns.

## Output

Severity: 🔴 **Critical** `[blocking]` (bugs, security, data loss, broken) · 🟡 **Warning**
`[non-blocking]` (convention violations, missing edge cases, weak tests) · 🔵 **Suggestion**
`[suggestion]` · 🟢 **Highlights** (only genuinely notable, no filler praise).

**Private first:** show findings in the terminal before posting; the developer may edit/add/remove
them. **Only after approval**, post to GitHub: inline comments on 🔴/🟡 lines (with severity label),
plus one summary comment (overview, counts by severity, all findings with file:line, highlights,
recommended next action).

## Post-review

- **No 🔴 and approved:** mark PR ready (remove draft); move the parent ticket to In Review
  (transition `3`, after confirming it's In Progress).
- **🔴 exist:** keep draft; summarise fixes needed (developer can run `capp-fix-ci-address-comments` or fix
  manually).
- Never move the parent task past Review.

## Rules

- Use a separate agent where available — independence matters.
- Do NOT auto-fix — document findings (fixing is the developer's / `capp-fix-ci-address-comments`'s job).
- Do NOT comment on commit history (PRs are squash-merged).
- Do NOT review generated files/lockfiles except to confirm they were regenerated correctly.
- Every comment must be actionable ("do this" / "consider this").
