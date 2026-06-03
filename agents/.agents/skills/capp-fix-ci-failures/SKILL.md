---
name: capp-fix-ci-failures
description: Diagnose and fix GitHub Actions CI failures on a pull request. Fixes code issues, validates locally using identified check tiers, and pushes focused fixes. Use when CI is failing on a PR.
---

# CaPP Fix CI

You are diagnosing and fixing CI failures on a pull request. Your goal is to make CI pass with high confidence — fix the failures, validate the failed check locally, then run the required local checks from `capp-identify-repo-checks` before pushing.

## Workflow Position

This skill runs after review comments have been addressed. It can also be used independently whenever CI is failing on a PR.

## Inputs

Expect:
- PR number or URL
- Latest PR head SHA
- Failed GitHub Actions check runs and logs
- Repo docs and validation tiers from `capp-identify-repo-checks`

## Outputs

Produce:
- Focused code/config fixes for the latest PR head SHA
- Local validation of the failed checks
- Required local validation before pushing
- PR comment or PR description update when appropriate

## Preflight

1. Identify the PR (ask if ambiguous)
2. Get the **latest PR head SHA** — only inspect check runs for this SHA. Ignore stale or superseded runs
3. Checkout the PR branch locally and ensure it's up to date
4. Run `capp-run-preflight-checks` in PR/CI-fix mode
5. Use the `capp-identify-repo-checks` output from preflight as the validation plan, including package manager detection

## Process

### 1. Diagnose

- Fetch failed check runs for the latest head SHA
- Read job logs for each failure
- If failures look stale or inconsistent, consider re-running the jobs before making code changes
- Categorise each failure:
  - **Test failure**: A test is failing
  - **Type error**: TypeScript compilation failure
  - **Lint error**: Linting rule violation
  - **Format error**: Code formatting issue
  - **Coverage**: Coverage threshold not met
  - **Build error**: Build or compilation failure
  - **Config error**: CI configuration issue
  - **Other**: Something else

### 2. Fix

For each failure:

**Code fixes first:**
- Attempt to fix without changing any configuration files
- Fix the specific issue, then validate it's resolved
- Changing test assertions is OK if the underlying logic hasn't fundamentally changed
- Do NOT fix tests that are failing in unrelated areas of the code

**Config changes as last resort:**
- Only if code fixes are exhausted AND there is a clear, justified fix in configuration
- Examples: new package missing from CI config, coverage threshold needs adjusting for genuinely new code
- **Require explicit developer approval** before:
  - Changing GitHub Actions workflows
  - Reducing coverage thresholds
  - Skipping tests
  - Changing lint or typecheck configuration
  - Changing package manager behaviour

**Escalate if:**
- The logic is genuinely wrong (not just a test or formatting issue)
- The failure is in code unrelated to this PR
- The fix would require significant refactoring

### 3. Validate — the critical step

This is where most CI fix attempts fail. Be thorough. **Goal: CI should pass on the next push.**

1. **Fix the specific failure** — run the exact check that was failing to confirm it passes
2. **Run every locally-runnable check from `capp-identify-repo-checks`** — not just the one that failed. This means:
   - All required local checks (lint, typecheck, unit tests, format, build)
   - All conditional checks relevant to the changed area (coverage, schema, bundle-size, etc.)
   - Common cascade pattern to avoid: test coverage missing → tests added → tests have wrong formatting → typecheck fails → CI still failing. Catch these before pushing
3. CI-only checks (secrets, external services, browsers, deployments) — only skip those that genuinely cannot run locally; document which will run on push
4. If any check fails, fix it and re-run the failed check plus the full local tier
5. Only push when you are confident every check that can run locally has passed

### 4. Commit and push

- Commit with a clear message: `fix: resolve CI failures [CAPP-1234]`
- If config was changed, add a prominent note in the commit message
- Push to the PR branch

### 5. Report

**PR comment** for routine fixes (test tweaks, formatting, import fixes).

**Update PR description** if:
- Configuration files were changed
- Significant logic was modified
- Coverage thresholds were adjusted

Flag any config changes prominently — both in the commit message and as a PR comment.

## Rules

- Do NOT fix failures in unrelated areas of code
- Do NOT push until all locally-runnable checks pass (required + applicable conditional)
- Do NOT change CI configuration without developer approval
- Do NOT hand-edit generated files or lockfiles
- Do update lockfiles through the package manager when dependency changes require it
- Reuse package manager and check discovery from `capp-identify-repo-checks`
- Always validate fixes locally before pushing — aim for one push that makes CI green
