---
name: capp-identify-repo-checks
description: CaPP — identify a repo's validation checks before push (package manager, scripts, GitHub Actions, CI-only checks; outputs targeted/required/conditional tiers). Internal; invoke explicitly.
---

# CaPP Identify Checks

Produce a practical validation plan for a repo — not a guarantee that every CI job can run locally.

**In:** repo path/cwd; ticket/PR context; affected packages/files if known; repo instructions
(AGENTS.md, CONTRIBUTING, README, package docs). If the affected area is unknown, identify repo-wide
checks and note which need narrowing once files change.
**Out:** package manager (+ evidence); the four check tiers below; notes on generated files,
lockfiles, secrets, external services; exact commands where safely inferable.

## Discovery order

1. **Repo instructions:** AGENTS.md, CONTRIBUTING, README + package READMEs, CONTEXT.md.
2. **Package manager:** `packageManager` in `package.json`; lockfiles (`pnpm-lock.yaml`,
   `yarn.lock`, `package-lock.json`, `bun.lockb`); workspace files (`pnpm-workspace.yaml`).
3. **Package scripts** (root + affected packages): lint, typecheck, test/test:unit, format/check,
   coverage, build, depcheck, generated-type checks, schema checks, bundle limits, repo-specific
   validation.
4. **GitHub Actions** (`.github/workflows/`) — the strongest signal for what CI expects. Map steps
   to local commands; note steps needing secrets, deployed services, browsers, external datasets, or
   CI-only infra.
5. **Other configs if present:** Turbo/Nx, Vitest/Jest/Playwright, ESLint/Prettier, TS project
   references, Sanity typegen/schema, Terraform/Terragrunt validation.

## Validation tiers

- **Targeted** (before each commit): tests for changed modules; the exact failed check after a fix;
  package-local lint/typecheck; generated type/schema checks for changed inputs.
- **Required local** (before pushing): lint, typecheck, unit tests, format check, build (if CI
  requires it and it's feasible locally).
- **Conditional** (when relevant): coverage (when thresholds touched / CI enforces); Sanity
  typegen/schema (schema or query changes); bundle-size (frontend/runtime); infra plan/synth/validate
  (infra changes); integration tests (documented local path).
- **CI-only** (document, don't run unless instructed): E2E/browser suites; deployment checks; checks
  needing production-like secrets/external services; long-running CI-only suites. Run E2E only when
  the developer explicitly asks or repo instructions require it.

## Policies

- **Package manager:** use the detected one only; don't switch. Prefer existing dependencies; ask
  before adding a runtime dependency. Don't hand-edit lockfiles, but regenerating via the package
  manager when dependencies change is fine.
- **Generated files:** don't hand-edit; run the documented generator (e.g. Sanity typegen flow).
- **Failure handling:** if a command can't be inferred safely, say what evidence is missing and ask.
  If a CI command can't run locally (secrets/external/CI-only), classify it CI-only and explain why.
