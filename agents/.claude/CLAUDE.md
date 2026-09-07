<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

## Signing GitHub comments

Sign every GitHub comment you author with a final line reading exactly:

`— AL-9000 🔴`

This applies to pull request descriptions and summaries, review bodies, issue
comments, and replies. It marks the comment as agent-authored so a human
reader knows at a glance who wrote it.

- **Sign top-level bodies, not every inline comment.** On a review that posts
  inline comments, the signature goes once on the review summary body — a
  signature on each of fifteen inline nits is noise.
- **Put it last**, after any collapsed `<details>` block, separated by a blank
  line so it renders on its own.
- **Not commit messages.** Those follow the repo's commit conventions; a
  signature line there pollutes `git log`.
