# Source

Vendored from Addy Osmani's agent-skills collection.

- Upstream: https://github.com/addyosmani/agent-skills/tree/main/skills/security-and-hardening
- Licence: MIT
- Imported: 2026-08-20

## Local changes

`SKILL.md` is verbatim. Added `agents/openai.yaml` for the repository
convention.

Upstream reads its checklists from `../../references/`. In this repository that
path resolves to `agents/.claude/references/`, so the paths need no change.

## Trigger

No `disable-model-invocation` flag. This skill must stay model-invocable
because `code-review-and-quality` names it as the place to go for detail. A
user-invoked skill cannot be reached that way.

## Still dangling

This skill names two skills that this repository does not have:

- `debugging-and-error-recovery`
- `observability-and-instrumentation`

Both exist upstream. The collection is interlinked, so each import can pull in
new names. Import them only if you want them for their own sake.
