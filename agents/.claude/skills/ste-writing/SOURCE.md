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
2. Left model-invocable. No `disable-model-invocation` flag. Other skills must
   be able to reach this one, and a user-invoked skill cannot be reached that
   way. The cost is context load: the description sits in the window every turn.
3. Rewrote the `description`. Upstream's version renamed one branch several
   times over ("not sound like AI", "clear or plain", "reads human"). This one
   keeps one trigger per branch and adds a reach clause for other skills.

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
