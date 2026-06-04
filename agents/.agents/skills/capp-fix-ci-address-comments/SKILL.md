---
name: capp-fix-ci-address-comments
description: Iterate on an open PR — address review comments (fix or push back with evidence) and/or fix failing GitHub Actions CI. Explicit invocation — "address PR comments", "fix CI".
---

# CaPP PR Iteration

Iterate on an open PR. Two modes, often used together:

- **Comments** — address review comments: fix, push back with evidence, or discuss; resolve threads.
- **CI** — diagnose and fix failing GitHub Actions checks.

Runs after human review / `capp-self-review`, or whenever an open PR needs changes.

## Preflight

1. Identify the PR (ask if ambiguous).
2. Run `capp-run-preflight-checks` in PR mode — this loads Jira metadata via `capp-get-jira-info`
   (for any Jira reads) and runs `capp-identify-repo-checks` (use its tiers as the validation plan).
3. **Comments:** fetch all review threads (unresolved comments, conversation comments, pending
   reviews); read the PR diff/description and linked ticket (`responseContentFormat: "markdown"`).
4. **CI:** get the **latest head SHA** (ignore stale runs); check out the PR branch up to date; fetch
   failed runs for that SHA and read each job log.

## Comments mode

**Classify each thread:** fix required · push back (code correct / reviewer mistaken / would worsen)
· discussion (conversation — no code change unless directed) · AGENTS.md update (reviewer asks for a
general rule).

- **Fix:** make the change → targeted checks on the affected package → reply citing the fix →
  resolve only after replying and completing it.
- **Push back:** assertive, with evidence (docs, codebase examples, test results, specs); never on
  preference alone. `@copilot`/bots carry less weight only on subjective style — fully investigate
  correctness, security, a11y, and CI findings. Reply with reasoning.
- **Discussion:** give context, examples, and a recommendation; no code changes unless asked.
- **AGENTS.md update:** only for general rules ("always prefer X", "we don't do this here"), not
  PR-specific feedback; include the change in the PR.

## CI mode

Categorise each failure (test/type/lint/format/coverage/build/config/other). If failures look stale,
consider re-running jobs first.

- **Code fixes first** — fix without touching config where possible; adjusting test assertions is OK
  if the underlying logic is unchanged.
- **Config changes are a last resort, needing explicit developer approval** — workflows, coverage
  thresholds, skipping tests, lint/typecheck/package-manager behaviour.
- **Escalate** if the logic is genuinely wrong, the failure is unrelated to this PR, or the fix needs
  significant refactoring.

## Validate, commit, report

- Validate per `capp-conventions` (targeted after each fix; all locally-runnable checks before push;
  CI green on first push). For CI mode, first re-run the exact failed check to confirm it passes.
- Commit clearly referencing the ticket (e.g. `fix: resolve CI failures [CAPP-1234]`); flag any
  config change prominently in the message.
- Update CONTEXT.md if changes introduced new terms/patterns.
- Push, then report: threads fixed / pushed back / unresolved (why); CI checks now passing; any
  config or AGENTS.md changes (note config changes as a PR comment or description update).
- Re-run `capp-self-review` only if changes were substantial (>3 files, significant logic, auth/
  security/data-fetching, Sanity schema/query, or reviewer-requested architecture).

## Rules

- Don't fix unrelated areas, change code for "discussion" comments unless directed, or delete/dismiss
  comments (always reply).
- Don't change CI config without approval or hand-edit generated files/lockfiles.
- Always cite evidence when pushing back; include any AGENTS.md update in the PR.
- Don't make destructive Jira changes.
