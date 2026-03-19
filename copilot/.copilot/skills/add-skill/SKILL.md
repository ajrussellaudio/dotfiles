---
name: add-skill
description: Import a skill from exactly one GitHub file URL, raw GitHub URL, or single-file gist URL into ~/.copilot/skills/. Use when the user wants to add a skill from GitHub content.
---

Import a Copilot skill from a GitHub-hosted text file into this repository.

## Scope

- Accept exactly one supported URL from the user's prompt.
- Supported inputs:
  - `https://github.com/<owner>/<repo>/blob/<ref>/<path>`
  - `https://raw.githubusercontent.com/<owner>/<repo>/<ref>/<path>`
  - single-file gist URLs on `gist.github.com` or raw gist URLs on `gist.githubusercontent.com`
- Refuse:
  - prompts with zero supported URLs
  - prompts with more than one supported URL
  - multi-file gists
  - private, missing, inaccessible, binary, or otherwise non-text targets
  - destinations that already exist

## Output Contract

Create the new skill immediately under:

`~/.copilot/skills/<normalized-name>/SKILL.md`

Then report:

- created path
- final `name:`
- final `description:`

Do not dump the whole file unless the user asks.

## Workflow

### 1. Validate the prompt

- Extract supported URLs from the user's prompt.
- Continue only when there is exactly one supported URL.
- If the prompt is invalid, stop and tell the user to provide exactly one supported URL.

### 2. Fetch the source text

Prefer the most direct structured fetch available in the current environment.

For repository files:

- For `blob` URLs, convert to the corresponding raw URL (`raw.githubusercontent.com`) before fetching, or use a GitHub file-content tool if one is available.
- For raw GitHub URLs, fetch directly.

For gists:

- Resolve the gist metadata first (e.g. via the GitHub API or by fetching the gist page).
- If the gist contains more than one file, refuse clearly; do not guess which file is the "main" one.
- If the gist contains exactly one file, fetch that file's raw text.

Only continue if the fetched content is text. If the content is binary, inaccessible, or missing, fail with a clear explanation.

### 3. Derive the skill name

Pick the destination skill name in this order:

1. existing front matter `name:` from the fetched file, if present
2. otherwise, the fetched filename stem

Normalize the chosen value to lowercase kebab-case (replace spaces and underscores with `-`, drop non-alphanumeric characters).

Use that same normalized value for both:

- the destination directory name
- the final `name:` field in `SKILL.md`

### 4. Check the destination

Target directory: `~/.copilot/skills/<normalized-name>/`

If that directory already exists, stop and refuse. Do not overwrite, merge, or partially update it. Tell the user to choose a different name or remove the existing skill first.

### 5. Build `SKILL.md`

**Source already has YAML front matter:**

- preserve all existing front matter keys
- rewrite `name:` to the normalized kebab-case value
- preserve `description:` if present
- synthesize `description:` only when it is missing (see step 6)

**Source has no YAML front matter:**

- generate front matter with `name:` and `description:` (see step 6)

**Body rules:**

- Markdown source: preserve the body verbatim after the final `---` front matter delimiter.
- Non-Markdown text source: place the raw text verbatim inside a fenced code block beneath the front matter. Use a fence length (number of backticks) that cannot be broken by any fence sequences already present in the source.

### 6. Infer `description:`

When a description must be synthesized, infer a short, concrete, action-oriented summary from the imported content that describes when the skill should be used. Match the style of existing skills: one sentence ending with a trigger phrase like "Use when…".

### 7. Write the files

- Create the destination directory.
- Write the final content to `~/.copilot/skills/<normalized-name>/SKILL.md`.
- Do not create any other files.

## Guardrails

- Do not follow links inside the fetched file.
- Do not guess a main file for multi-file gists.
- Do not silently coerce binary content into text.
- Do not overwrite an existing skill directory.
- Do not continue after a failed fetch.

## Success Response

```
Created: ~/.copilot/skills/<normalized-name>/SKILL.md
name: <normalized-name>
description: <final description>
```
