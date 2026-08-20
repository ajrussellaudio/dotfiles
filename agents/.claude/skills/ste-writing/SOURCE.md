# Source

Vendored from Ege Çelebi's "The cure for AI slop is a 1986 aircraft manual" kit.

- Upstream: https://github.com/woosal1337/blog/tree/main/videos/ep01-the-cure-for-ai-slop
- Imported: 2026-08-20
- Files taken verbatim: `SKILL.md` (upstream `ste-writing-skill.md`),
  `ste-recurring-errors.md`, `ste-lint.py`

## Local changes

`SKILL.md` only. No rule text was changed.

1. Bundled-file paths made absolute (`~/.claude/skills/ste-writing/...`) so the
   lint step and the recurring-errors link resolve when the skill runs from a
   project directory instead of the skill directory.
2. Added `disable-model-invocation: true`. This skill is user-invoked only, to
   match the other workflow skills in this repo.
3. Replaced the `description` with a one-line human-facing summary. The upstream
   description was a trigger list for model matching. A user-invoked skill hides
   its description from the agent, so the list had no reader.

Upstream description, kept here for a future re-merge:

> Rewrite prose (docs, READMEs, PR descriptions, error messages, release notes,
> comments, tool descriptions, system prompts — never code) into ASD-STE100
> Simplified Technical English to remove "AI slop". Use when asked to make
> writing not sound like AI, make docs clear or plain, enforce a controlled
> writing style, review text for STE violations, or write technical
> documentation that reads human. Two modes — strict (procedures/safety) and
> STE-flavored (general prose).

## Upstream licence

MIT, Copyright (c) 2026 Ege Çelebi. The upstream LICENSE covers source code;
blog prose and images are reserved. This kit lives under `videos/` and is
code-side, so MIT applies.

Unofficial and not affiliated with ASD. ASD-STE100 is a registered EU trademark
(No. 017966390). The spec itself is free at https://asd-ste100.org and is not
redistributed here.

## Depended on by

`code-review-and-quality` writes its review report in STE. Its "Writing the
Review" section hard-codes two paths in this directory:

- `~/.claude/skills/ste-writing/SKILL.md`
- `~/.claude/skills/ste-writing/ste-lint.py`

It reads and runs those files. It does not invoke this skill, so
`disable-model-invocation: true` stays correct. If you rename or move this
directory, update that section.
