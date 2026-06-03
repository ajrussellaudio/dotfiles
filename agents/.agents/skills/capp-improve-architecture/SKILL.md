---
name: capp-improve-architecture
description: Find and implement architectural improvements in a codebase. Identifies shallow modules, tight coupling, and missing abstractions, then helps create tickets or make direct fixes. Use explicitly — "improve architecture", "refactor module X", or invoke by skill name.
---

# CaPP Improve Architecture

You are helping a developer identify and implement architectural improvements in a codebase. This skill focuses on making modules deeper, interfaces cleaner, and dependencies more explicit.

## When to Use

This is a **supporting skill** outside the main development workflow.

**Explicit invocation only.** This skill should only run when the developer deliberately asks for it using:
- The skill name: `capp-improve-architecture`
- Explicit language: "improve architecture", "refactor module X", "improve codebase structure"

Do NOT trigger for routine development tasks — use `capp-do-work` for ticket work.

## Inputs

Expect a repository path/current working directory and an explicit architecture/refactor goal or area to inspect. A Jira ticket is preferred for implementation work but not required for read-only analysis.

## Outputs

Produce grounded architecture findings and, if the developer explicitly chooses implementation, a scoped refactor with validation and a PR. Significant changes should include a before/after architecture note.

## Concepts

These concepts guide the analysis. Use the full vocabulary but always ground it in concrete codebase examples using the repo's own terms.

### Module depth

A deep module has a simple interface that hides significant complexity. A shallow module exposes most of its complexity through its interface, adding overhead without hiding anything. Look for modules where the interface is almost as complex as the implementation.

### Seams

Natural boundaries in the code where modules meet. Good seams are explicit, narrow, and well-typed. Bad seams are implicit (hidden dependencies), wide (too many things crossing), or untyped.

### Information hiding

Each module should encapsulate its internal complexity. When internals leak through exports, naming, or required knowledge, the module becomes harder to use and change independently.

## Process

### 1. Explore

Use **parallel agents** to scan the codebase where available. If sub-agents are unavailable, perform equivalent separate exploration passes:
- Module boundaries and interfaces
- Import/export patterns and dependency graphs
- Public API surface area vs internal complexity
- Naming conventions and consistency
- Code duplication across modules
- Areas where changes tend to cascade

Read AGENTS.md, CONTEXT.md, and any existing architecture documentation.

### 2. Identify opportunities

For each finding:
- **What**: Describe the issue using codebase terms
- **Why it matters**: Impact on maintainability, testability, or developer experience
- **Severity**: How urgently should this be addressed?
- **Effort**: Rough size (small refactor vs significant rearchitecture)

Categorise findings:
- **Quick wins**: Small refactors that can be done directly
- **Medium improvements**: Need a ticket but are straightforward
- **Significant changes**: Need a ticket, PRD, and careful planning

### 3. Suggest next steps

Present findings and let the developer choose:

**For quick wins:**
- Offer to make the changes directly
- Prefer creating or linking a lightweight Jira ticket unless the developer explicitly says no ticket is needed
- Follow the same rigour as `capp-do-work`: TDD where practical, run targeted checks before commits, run all locally-runnable checks (required + applicable conditional) from `capp-identify-repo-checks` before pushing so CI passes on first push, create a PR

**For medium and significant changes:**
- Encourage creating a ticket using `capp-create-a-ticket`
- Then write a PRD using `capp-write-prd`
- The developer may choose to implement medium changes directly — that's fine

### 4. Implementation (if chosen)

If the developer opts to make changes directly:
- Run `capp-run-preflight-checks` before changing files
- Use **single agents** for all writing and changes (no parallel writes)
- Use **parallel agents** for reading and exploration where available
- Follow TDD where practical
- Use `capp-identify-repo-checks` for validation tiers
- Create a PR with a clear description of the architectural improvement
- Follow repo PR template and conventions from AGENTS.md, CONTRIBUTING.md, and PR templates

### 5. Documentation

If the changes are significant:
- Update CONTEXT.md with new terms or changed patterns (if it exists)
- Offer to create or update architecture documentation
- Consider whether an ADR (Architecture Decision Record) is warranted
- Include a before/after architecture note in the PR or docs

## Rules

- **Parallel agents for reading, single agent for writing**
- Do NOT refactor without the developer's explicit approval
- Do NOT change public interfaces without confirming downstream impact
- Do NOT mix architectural improvements with feature work — keep them separate
- Do NOT hand-edit generated files or lockfiles
- Use the codebase's own terminology, not abstract architecture jargon
- Every finding should be grounded in a concrete example from the code
