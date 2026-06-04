---
name: capp-review-improve-architecture
description: Explore/understand a codebase's architecture (Review mode) or find and implement architectural improvements (Improve mode). Explicit invocation — "review architecture", "improve architecture", "refactor module X".
---

# CaPP Architecture

Supporting skill (outside the main workflow), **explicit invocation only**. Two modes:

- **Review** — understand and explain architecture; read-only.
- **Improve** — find and implement deepening/decoupling improvements.

Pick the mode from the request; ask if unclear. Do NOT trigger for routine ticket work — use
`capp-do-work`.

## Shared concepts (ground every point in concrete code, using the repo's own terms)

- **Module depth:** deep = simple interface hiding real complexity; shallow = interface nearly as
  complex as its implementation. Find shallow modules.
- **Seams:** module boundaries. Good = explicit, narrow, well-typed; bad = implicit/wide/untyped.
- **Information hiding:** internals leaking via exports/naming/required knowledge make a module hard
  to change.

## Explore (both modes)

Parallel agents where available (else separate passes). Read repo root (README, AGENTS.md,
CONTRIBUTING, CONTEXT.md, package.json, workspace config); map directory/package/module layout and
key configs; trace import/export patterns, dependency graphs, public API surface vs internal
complexity, naming consistency, duplication, and cascade-prone areas.

## Review mode

1. **Overview:** package/module map (name, purpose, key deps; grouped core/domain/config); patterns
   (data flow, shared vs domain boundaries, key abstractions, external integrations — CMS/APIs/CDN);
   3–5 areas worth exploring, flagging anything complex/risky without prescribing a refactor.
2. **Interactive Q&A:** the developer drives; dive into relevant code, explain patterns, ground in
   concrete examples; mid-to-senior level; suggest further areas.
3. **Persistence:** keep findings in session memory; at break points offer to save as CONTEXT.md
   (glossary) or an architecture doc — ask before committing.

## Improve mode

1. **Identify opportunities** — per finding: what (codebase terms), why it matters (maintainability/
   testability/DX), severity, effort. Categorise: quick wins (small, direct), medium (need a ticket),
   significant (ticket + PRD + planning).
2. **Suggest next steps:** quick wins → offer to implement directly, preferring a lightweight ticket
   unless declined; medium/significant → `capp-create-a-ticket` then `capp-write-prd`.
3. **Implementation (if chosen):** run `capp-run-preflight-checks`; **single agent for writing**
   (parallel agents only for reading); TDD where practical; validate and push per `capp-conventions`;
   PR following the repo template. Significant changes: update CONTEXT.md, consider an ADR, include a
   before/after note.

## Rules

- Parallel agents for reading; single agent for writing.
- Review mode is read-only — never prescribe refactors there (descriptive risk flags are OK).
- Improve mode: no refactor without explicit approval; don't change public interfaces without
  confirming downstream impact; don't mix architectural work with feature work.
- Use the codebase's own terminology; ground every finding in a concrete example.
