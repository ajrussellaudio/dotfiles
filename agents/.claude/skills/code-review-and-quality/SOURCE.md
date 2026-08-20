# Source

Vendored from Addy Osmani's agent-skills collection.

- Upstream: https://github.com/addyosmani/agent-skills/tree/main/skills/code-review-and-quality
- Licence: MIT
- Resynced: 2026-08-20

## Local changes

`SKILL.md` is upstream verbatim, plus `### Step 6: Clean the Review Before You
Send It` in `## Review Process`, and one line in `## The Review Checklist`. The
step applies the `ste-writing` skill to the review report, so the report itself
is not slop.

Step 6 sits in the ordered flow and the checklist asks for it, so it has a
trigger. An earlier version was a free-standing `## Writing the Review` section
that nothing referred to, which left it to chance.

The step names the skill and its mode. It holds no path, no script name, no
score threshold, and no output field. Those belong to `ste-writing`, which
documents how to run its linter and how to read the result. This skill only
states that the review goes through it and reports what it measured.

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
