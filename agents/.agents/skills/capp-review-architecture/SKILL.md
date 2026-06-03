---
name: capp-review-architecture
description: Explore and understand the architecture of a codebase. Provides a high-level overview then interactive Q&A for deeper exploration. Use when onboarding to a repo or understanding how it's structured.
---

# CaPP Review Architecture

You are helping a developer understand the architecture of a codebase. Start with a high-level overview, then enter an interactive Q&A mode where the developer can explore specific areas in depth.

## When to Use

This is a **supporting skill** outside the main development workflow. Use when:
- Onboarding to a new repository
- Understanding how a codebase is structured before making changes
- Investigating complex or unclear areas
- Building mental models of module relationships

## Inputs

Expect a repository path/current working directory and optionally a specific area, package, module, or architectural question.

## Outputs

Provide a high-level architecture overview, areas worth exploring, and interactive Q&A grounded in the codebase's own terminology. Findings are informational unless the developer explicitly asks to turn them into documentation or implementation work.

## Process

### 1. Explore the codebase

Use **parallel agents** for fast exploration where available. If sub-agents are unavailable, perform equivalent separate exploration passes:
- Read the repo root: README, AGENTS.md, CONTRIBUTING.md, CONTEXT.md, package.json, workspace config
- Map the top-level directory structure
- Identify the package and module layout
- Note key configuration files (tsconfig, next.config, sanity config, etc.)

Useful delegation boundaries are repo structure/config, domain modules, tests/checks, and external integrations. Merge findings before presenting.

### 2. Present the overview

Provide a high-level map:

**Package/module map:**
- Name, purpose, and key dependencies for each top-level module
- Group related modules (e.g. "Core packages", "Domain packages", "Config")

**Key architectural patterns:**
- How data flows through the system
- Shared vs domain-specific code boundaries
- Key abstractions and their purpose
- External service integrations (CMS, APIs, CDN)

**Areas of interest:**
- Proactively suggest 3-5 areas worth exploring further
- Highlight anything that looks particularly complex, unusual, risky, or noteworthy without prescribing a refactor

### 3. Interactive Q&A

After the overview, enter Q&A mode:
- The developer can ask questions about any area
- They can follow your suggestions or explore their own interests
- For each question, dive into the relevant code, explain patterns, and surface important details

**Q&A approach:**
- Use terminology from the codebase (domain, package, module, service)
- Aim at a mid-to-senior developer level
- Layer in technical depth only where complexity demands it
- When explaining patterns, ground them in concrete examples from the code
- Suggest further areas to explore, but let the developer drive

### 4. Persistence

- Keep findings in conversation/session memory as you go (useful for long conversations)
- At natural break points, offer to save findings as documentation:
  - CONTEXT.md for domain glossary
  - Architecture overview in docs/ or similar
  - Ask the developer if they want to commit any of this

## Rules

- Use **parallel agents** for reading and exploration where available — speed matters
- Do NOT make any code changes — this is a read-only exploration skill
- Do NOT prescribe refactors — that's `capp-improve-architecture`'s job. Descriptive risk flags are OK
- Use the codebase's own terminology, not generic software architecture jargon
- Keep the overview scannable — depth comes in Q&A
