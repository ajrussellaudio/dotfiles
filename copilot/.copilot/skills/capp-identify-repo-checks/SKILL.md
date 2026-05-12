---
name: capp-identify-repo-checks
description: Identify the validation checks a repository expects before code is pushed. Discovers package manager, package scripts, GitHub Actions workflows, CI-only checks, and outputs targeted/required/conditional tiers. Use before implementing, addressing review comments, or fixing CI.
---

# CaPP Identify Checks

You are identifying the checks that should run before code is pushed. Your output is a practical validation plan, not a guarantee that every CI job can or should run locally.

## Inputs

Expect some or all of:
- Repository path or current working directory
- Ticket or PR context
- Affected packages/modules/files, if already known
- Repo instructions such as AGENTS.md, CONTRIBUTING.md, README, or package-level docs

If the affected area is unknown, identify repo-wide checks and note which checks need narrowing once files are changed.

## Outputs

Return a concise validation plan with:
- Package manager and evidence used to identify it
- Targeted checks to run before each commit
- Required local checks to run before pushing
- Conditional checks to run when relevant
- CI-only checks that should be left to CI or explicitly requested
- Notes for generated files, lockfiles, secrets, or external services
- Exact commands where they can be inferred safely

## Discovery order

1. Read repo instructions:
   - AGENTS.md
   - CONTRIBUTING.md
   - README and package-level READMEs
   - CONTEXT.md or equivalent domain/architecture docs if present
2. Detect package manager:
   - `packageManager` in `package.json`
   - lockfiles: `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`, `bun.lockb`
   - workspace files such as `pnpm-workspace.yaml`
3. Inspect package scripts:
   - root `package.json`
   - affected package `package.json` files
   - scripts for lint, typecheck, test, test:unit, format/check, coverage, build, depcheck, generated type checks, schema checks, bundle limits, and repo-specific validation
4. Inspect GitHub Actions workflows in `.github/workflows/`.
   - Treat workflows as the strongest signal for what CI expects.
   - Map CI steps back to local commands where possible.
   - Note checks that rely on secrets, deployed services, browsers, external datasets, or CI-only infrastructure.
5. Inspect other CI/config files if present:
   - Turbo/Nx configs
   - Vitest/Jest/Playwright configs
   - ESLint/Prettier configs
   - TypeScript project references
   - Sanity typegen/schema scripts
   - Terraform/Terragrunt or infrastructure validation scripts

## Validation tiers

### Targeted checks

Run targeted checks before each commit.

Examples:
- Tests for changed modules or packages
- The exact failed check after a fix
- Package-local lint/typecheck when available
- Generated type/schema checks for changed generated-type inputs

### Required local checks

Run required local checks before pushing.

Examples:
- Lint
- Typecheck
- Unit tests
- Format check
- Build, if CI requires it and it is feasible locally

### Conditional checks

Run conditional checks when relevant to the changed area.

Examples:
- Coverage when coverage thresholds are touched or CI enforces coverage
- Sanity typegen/schema checks for schema or query changes
- Bundle-size checks for frontend/runtime changes
- Infrastructure plan/synth/validate for infrastructure changes
- Integration tests when the affected code has a local, documented integration test path

### CI-only checks

Document but do not run locally unless explicitly instructed.

Examples:
- E2E/browser suites
- Deployment checks
- Checks requiring production-like secrets or external services
- Long-running integration suites intended only for CI

E2E checks must only be run when the developer explicitly asks for them or repo instructions for the current task require them.

## Package manager and dependency policy

- Use the detected package manager only.
- Do not switch package managers.
- Prefer existing dependencies and utilities.
- Ask before adding a new runtime dependency.
- Do not hand-edit lockfiles.
- It is OK to regenerate/update lockfiles through the package manager when dependency changes require it.

## Generated file policy

- Do not hand-edit generated files.
- If generated output is required, run the repo's documented generator.
- For Sanity types, use the documented typegen flow rather than editing generated type files.

## Failure handling

If a command cannot be inferred safely, say what evidence is missing and ask the developer. If a CI workflow uses a command that cannot run locally because of secrets, external services, or CI-only setup, classify it as CI-only and explain why.
