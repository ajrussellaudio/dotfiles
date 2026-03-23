---
name: notes-to-tasks
description: Read a scratch notes file (e.g. NOTES.md), explore the codebase to understand each item in context, flag already-implemented items, and grill the user on anything unclear — producing a clean, agreed task list ready for planning. Use when a user has rough notes or bullet points they want to turn into actionable work items.
---

# Notes to Tasks

Turn a rough scratch notes file into a clean, agreed list of actionable tasks by triaging each item against the codebase and grilling the user on anything ambiguous.

## Process

### 1. Find the notes file

Look for `NOTES.md` in the repository root. If it does not exist, ask the user which file to read.

### 2. Read and parse the notes

Read the file. Treat each line or bullet point as a separate candidate task. Blank lines and headings are not tasks.

### 3. Explore the codebase

Before asking the user anything, explore the codebase to understand each note in context. For each candidate task, determine:

- **Already done** — the behaviour described is already implemented.
- **Clear** — the intent is unambiguous; can be turned into a task as-is. Note whether it is likely to spawn sub-tasks.
- **Unclear** — the intent is ambiguous or the implementation approach is non-obvious.

Use sub-agents for exploration to avoid burning your primary context window.

### 4. Triage silently

Do not surface already-done items as tasks. You will mention them to the user later as a courtesy, but do not spend interview time on them.

### 5. Grill the user on unclear items

For each **unclear** item, ask exactly one focused question at a time using the `ask_user` tool. Do not bundle multiple questions into one.

Good grilling questions:
- Ask what specific problem the note is describing ("What were you running into when you wrote this?")
- Ask about scope ("Should this be a simple X or a full Y?")
- Ask about trade-offs that affect implementation ("Should we store A or copy to B?")
- Ask about trigger / entry point ("How does the user activate this?")

If a question can be answered by exploring the codebase further, explore it instead of asking.

### 6. Present the complete task list

Once all unclear items are resolved, present the full task list to the user. Format:

```
## Tasks

1. **Title** — one-sentence description. _(may spawn sub-tasks)_
2. **Title** — one-sentence description.
...

## Already implemented (no action needed)
- Item text — brief explanation of where/how it exists.
```

Ask the user to confirm the list is correct and complete before declaring the skill done. Adjust based on their feedback.

### 7. Hand off

Once the user confirms, the output is ready to feed into `prd-to-plan` or `prd-to-issues`. Mention this if appropriate.

## Ground rules

- **One question at a time.** Never ask two questions in one `ask_user` call.
- **Prefer codebase exploration over user questions.** If you can answer it yourself, do so.
- **Flag already-done items as a courtesy, not as tasks.** The user may not know they are already implemented.
- **Each task should be independently understandable.** A reader should know what to build without re-reading the notes file.
- **Do not start planning or writing issues.** This skill ends when the task list is agreed. Subsequent skills handle planning and issue creation.
