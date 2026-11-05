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

## What to post without asking

Writing that people only read goes out without asking first. Actions that
change state wait until I ask for that specific action. This overrides the
skills' "confirm before posting" and "approve only when asked" rules (in
`twinkl-core:github`, `twinkl-core:review` and `twinkl-core:jira`), but only
for the first list.

- **Post or edit freely:**
  - comments on PRs and issues, and review replies;
  - PR reviews, including approving and requesting changes;
  - PR titles and descriptions;
  - Jira comments, and a Jira ticket's description.

  Link to what you posted in your reply, so I can see what went out.
- **Never without an explicit ask:**
  - merging, closing or reopening a PR;
  - requesting reviewers;
  - creating, transitioning or assigning a Jira ticket, or changing its sprint.

  "Address the feedback" covers posting the replies. It doesn't cover
  merging the PR or moving its ticket afterwards.
- **A reply that promises a follow-up ticket** still needs the ticket to exist
  first (see "Declining a review finding"). Creating it is structural, so ask
  before you create it, then reply with its key.

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

## Coding discipline

Adapted from [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills).
These bias toward caution over speed; on trivial tasks, use judgment.

- **Think before coding.** State your assumptions. When a request has several
  readings, lay them out instead of picking one silently; when a simpler
  approach exists, say so and push back. If something is unclear, name what
  confuses you and ask before implementing.
- **Simplicity first.** Write the minimum code that solves the problem asked:
  no speculative features, single-use abstractions, unrequested
  configurability, or error handling for impossible cases. If 200 lines could
  be 50, rewrite it. Test: would a senior engineer call it overcomplicated?
- **Surgical changes.** Every changed line traces to the request. Match the
  existing style, leave adjacent code, comments and formatting as they are,
  and mention unrelated dead code rather than deleting it. Do remove the
  imports, variables and functions your own change orphaned.
- **Goal-driven execution.** Turn the task into a verifiable goal and loop
  until it's met: "fix the bug" becomes "write a test that reproduces it, then
  make it pass"; "refactor X" becomes "tests pass before and after". For
  multi-step work, state a brief plan with a check per step
  (`1. [step] → verify: [check]`).
