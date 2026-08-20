# Source

Vendored from Addy Osmani's agent-skills collection.

- Upstream: https://github.com/addyosmani/agent-skills/tree/main/skills/code-review-and-quality
- Licence: MIT
- Resynced: 2026-08-20

## Local changes

`SKILL.md` is upstream verbatim, plus one added section: `## Writing the Review`.
That section applies the `ste-writing` skill to the review report, so the report
itself is not slop.

The section names that skill and nothing else. It holds no path into the skill's
directory, so `ste-writing` stays free to move or change its internals.

Re-apply that section after each resync. Insert it before
`## Dependency Discipline`.

## Resync of 2026-08-20

The earlier copy was stale. It predated `## Structural Remedies`, the
total-file-size signal in `## Change Sizing`, the finding-order rule, the
dependency-upgrade workflow, and several readability and architecture bullets.

It also carried a severity bug. Its own table defined Required, Critical,
Optional, Nit, and FYI, but the review-prompt example asked for "Critical,
Important, or Suggestion" and `## Verification` checked "All Important issues".
Neither term existed in the table. The resync fixed both.

An earlier local edit rewrote the `../../references/` paths to `references/`.
That edit is reverted. In this repository `../../references/` resolves to
`agents/.claude/references/`, so upstream's paths are correct as written.

## Shared references

`agents/.claude/references/` holds the checklists. Upstream's
`security-and-hardening` and `performance-optimization` skills read the same
two files, so the directory is shared and not skill-local.
