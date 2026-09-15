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

## Checking whether a branch is merged

**Twinkl repos squash-merge**, so a merged branch's head is never an ancestor
of `main` — the squash is a new commit with a different SHA.

- **Never use `git merge-base --is-ancestor <head> origin/main`** to decide
  this. It reports correctly merged work as unmerged, which is how a
  legitimate worktree cleanup gets refused.
- **Check instead** for the squash commit on `main`
  (`git log --oneline -40 origin/main | grep '#<PR>'`), or the PR's
  `merged_at`. GitHub's **list**-pull-requests endpoint leaves `merged` false
  even when `merged_at` is set; the single-PR endpoint populates it properly.
- Confirm the shape when unsure: `git log --merges --oneline -40 origin/main`
  returning nothing means squash-or-rebase only, so ancestry proves nothing.
- A consequence worth remembering: because every PR lands as one commit,
  **commit granularity inside a PR is reviewer convenience only.** Don't
  rewrite history or restructure tickets to tidy it.

## Declining a review finding

When a review raises something real that is genuinely out of scope, the reply
is almost always "raising this as a follow-up rather than dropping it."

- **Create the ticket first, then reply with its key.** Never reply with the
  promise intending to raise it afterwards — the PR gets approved and merged,
  and the reviewer has no way to tell "tracked elsewhere" from "ignored".
- Commentary dies with the session; only artifacts survive it. A promise in a
  PR description or review reply has an external reader, so it is a commitment
  rather than a note to self.
- An item you have repeated across several turns needs writing down **now**.
  Repetition is not tracking.
