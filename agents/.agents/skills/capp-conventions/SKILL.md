---
name: capp-conventions
description: Shared CaPP rules — CMS/Sanity, validate-before-push, generated files, PR templates, review independence. Internal; referenced by other capp-* skills, not invoked directly by users.
---

# CaPP Shared Conventions

Cross-cutting rules referenced by the CaPP workflow skills. Load when a skill points here.

## CMS / Sanity

- CMS schema, content, and UI changes should be **separate tickets/PRs**, each with its own PR in
  its repo.
- If schema + UI must ship together (a small, confirmed bug/task), do **schema first** so the UI can
  use the generated types.
- Never hand-edit generated Sanity types — use the documented typegen flow, or `--pr <pr-num>` for
  unreleased schemas.

## Validate before push — CI should pass on the first push

- **Per commit:** run the **targeted** tier from `capp-identify-repo-checks` (affected tests, the
  exact failed check, package-local lint/typecheck, changed generated-type/schema checks).
- **Before pushing:** run **all** locally-runnable checks — every required local check plus the
  conditional checks relevant to the change.
- Skip only genuine **CI-only** checks (secrets, deployed services, browsers, external datasets) and
  state which will run on push.
- Watch for cascades (e.g. add tests → wrong formatting → typecheck fails). Fix every failure before
  pushing.

## Generated files & lockfiles

Don't hand-edit generated files or lockfiles; regenerate via the documented tool / package manager
when changes require it.

## PR template discovery

Check in order, preserve required sections, don't invent undocumented conventions:
`.github/pull_request_template.md` → `.github/PULL_REQUEST_TEMPLATE.md` →
`.github/PULL_REQUEST_TEMPLATE/` → `CONTRIBUTING.md` / repo PR guidance.

## Review independence

Use a **separate agent** for code review where available (especially substantial, risky, security,
data-fetching, Sanity, or cross-package changes); otherwise do an equivalent separate pass.
