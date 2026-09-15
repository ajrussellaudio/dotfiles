# Issue tracker: Obsidian

Issues and specs (you may know a spec as a PRD) for this repo live as notes in an Obsidian vault.
Operations are plain file reads and writes — Obsidian has no CLI and needs none; a vault is a
directory of markdown files. Obsidian watches the filesystem, so edits made while it's open appear
live.

## Vault settings

_Record this repo's vault here before first use._

**Vault path:** `<absolute path to the vault root>`
**Effort folder:** `<folder inside the vault>` — e.g. `Efforts`

The vault normally lives **outside** the repo, so nothing this tracker writes is version-controlled
alongside the code. Resolve every path below against the vault path above.

## Conventions

- One effort per folder: `<effort folder>/<Effort Name>/`
- Note filenames are the **human-readable title**, not a number-slug — `Pick the slug strategy for migrated posts.md`. The filename is both the link target and the display name, which is what lets `[[...]]` references read as names.
- **Identity is the note name** — there are no issue numbers. Keep ticket titles unique across the vault: `[[Name]]` resolves by name, and a duplicate elsewhere in the vault makes the reference ambiguous.
- State lives in **frontmatter properties**, never in body lines: `status`, `type`, `blocked-by`, `assignee`, `created`.
- The spec is `<effort folder>/<Effort Name>/Spec.md`
- Triage state is the `status` property (see `triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the note under a `## Comments` heading
- Links between notes are always `[[wiki-links]]`. In frontmatter they **must be quoted** — `map: "[[My Map]]"` — or Obsidian stores them as plain text and they never reach the graph or the backlinks pane.

## When a skill says "publish to the issue tracker"

Create a new note under `<effort folder>/<Effort Name>/`, creating the folder if needed.

## When a skill says "fetch the relevant ticket"

Read the note. The user will normally pass the note name or its path; resolve a bare name against
the effort folder.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a note; its **child tickets** are notes in the same folder that
link back to it.

- **Map**: `<effort folder>/<Effort Name>/<Effort Name>.md` with frontmatter `wayfinder: map`, holding the Destination / Notes / Decisions-so-far / Not-yet-specified body. Naming the folder note after its folder keeps the map the obvious entry point in the file explorer.

- **Child ticket**: a note in the map's folder, with the question in the body and this frontmatter:

  ```yaml
  ---
  wayfinder: ticket
  map: "[[<Effort Name>]]"
  type: grilling # research | prototype | grilling | task
  status: open # open | claimed | resolved
  blocked-by:
    - "[[Decide the target content model]]"
  assignee:
  created: 2026-09-11
  ---
  ```

  `type` replaces the `wayfinder:<type>` label the issue-based trackers use. `created` is what
  orders the frontier, so always set it.

- **Blocking**: **forward links in frontmatter** — `blocked-by` is a YAML list of quoted wiki-links to the blocking tickets. This is the canonical representation, and it is a real link: it renders in the graph view and in each blocker's backlinks pane, so the human sees the dependency structure _and its direction_ without opening the map. A ticket is **unblocked** when every note in its `blocked-by` list has `status: resolved`; an empty or absent list means unblocked. Renaming a blocker is safe — Obsidian rewrites the wiki-link in every note referencing it, frontmatter included (needs Settings → Files and links → "Automatically update internal links", on by default).

- **Frontier query**: two views of the same set.

  - _For the human_ — the UI-visible frontier. Graph view and backlinks are core Obsidian, so the blocking structure is visible with no plugins installed. For a list, put a Bases view or a Dataview block in the map body:

    ```dataview
    TABLE type, blocked-by
    FROM "<effort folder>/<Effort Name>"
    WHERE wayfinder = "ticket" AND status = "open" AND !assignee
    SORT created ASC
    ```

    Dataview can't resolve each blocker's status in the same pass, so blocked tickets still appear in
    that table — read the `blocked-by` column as the gate.

  - _For the agent_ — Dataview and Bases render inside Obsidian only; you cannot execute them. Resolve the frontier by reading frontmatter directly: take the notes in the effort folder with `wayfinder: ticket`, drop any whose `status` isn't `open`, drop any with an `assignee`, then for each survivor read every note in its `blocked-by` and drop it unless all of them are `status: resolved`. Earliest `created` wins.

- **Claim**: set `status: claimed` and `assignee: <the driving dev>`, and save — the session's first write.

- **Resolve**: append the answer under an `## Answer` heading, set `status: resolved`, then append a context pointer to the map's Decisions-so-far as `- [[<Ticket Name>]] — <one-line gist>`. A wiki-link carries the name and the link as one token, which is the form wayfinder's "refer by name" rule asks for.
