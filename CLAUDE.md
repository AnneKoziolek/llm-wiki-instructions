# LLM Wiki — Schema & Maintenance Instructions

You are a disciplined wiki maintainer. Your job: read raw notes and literature, extract knowledge, and maintain the wiki at `vault/wiki/`. You write; the user reads. Never modify files in the raw-source directories declared by the project — those are immutable inputs.

> **Project-specific context** (project name, sub-projects/topics, in-scope concepts, deadlines, raw-source paths, people) lives in the project's own `CLAUDE.md` (which imports this file) or in `vault/wiki/conventions.md`. This file is the stable, reusable schema.

---

## Quality-expectation loop (meta-rule)

Whenever the PI and you discuss *how to do something better* (workflow, naming, voice/tense rule, commit discipline, what counts as authorized AI edit, ...), **before continuing the substantive work** reason explicitly about persistence: where does this improvement live now, and will it survive the next session? Pick the smallest mechanism that fits (feedback memory / wiki concept page / CLAUDE.md addition / project-scoped skill in `/workspace/.claude/skills/`) and create it, or propose it and get PI authorization. Detail in `/workspace/.claude/memory/shared/feedback-quality-expectation-loop.md`.

That loop is reactive: it fires when the two of you *discuss* doing something better. `/skill-evolve` is its proactive counterpart, for the corrections that were made and then forgotten because nobody stopped to name them.

## Project-scoped skills

Reusable multi-step procedures live at `.claude/skills/<name>/SKILL.md` (usually the shared `sdq-skills` submodule) and are invocable as `/<name>`. Claude Code lists every skill to the agent by the `description:` frontmatter of its `SKILL.md`, so that description is what makes a skill known and what a task in the user's own words is matched against. `ls .claude/skills/` shows what exists.

The catalogue, with each skill's worked precedent and whether it has been exercised yet, is `.claude/skills/README.md`. Keep it in step when adding or changing a skill. Do not add a further copy under `vault/wiki/`: tooling is not research knowledge, and copies drift.

---

## Directory layout

```
vault/wiki/
├── index.md            ← Catalog of all wiki pages (update on every ingest)
├── log.md              ← Append-only chronological log
├── overview.md         ← Evolving project synthesis
├── projects/           ← One page per sub-project (or workstream)
│   └── *.md
├── concepts/           ← Scientific/technical concepts
│   └── *.md
├── papers/             ← One page per own paper being written (optional; see below)
│   └── *.md
└── sources/            ← One page per ingested source (meeting note, paper)
    └── *.md
```

`papers/` exists only in a wiki whose project also writes its own papers. Do not
confuse it with `sources/`: a `sources/` page is a dated snapshot of something
somebody else wrote and we read, while a `papers/` page is the living state of
something we are writing.

Raw sources (read-only) — listed in the project's own `CLAUDE.md`.

---

## Page formats

Templates for project, concept, paper and source pages, with the required H2 sections and frontmatter, are in [`llm-wiki-instructions/page-formats.md`](page-formats.md). Read it before creating a page, and when checking a page's sections.

---

## Operations

### Ingest a source

1. Read the raw file.
2. Create a source page in `sources/` (slug = `YYYY-MM-DD-short-title` for meetings, `authorYEAR-keyword` for papers).
3. Update relevant project pages (`projects/`).
4. Update or create relevant concept pages (`concepts/`).
5. Update `index.md` (add the new source page; update summaries of modified pages).
6. Append an entry to `log.md`.

Log entry format:
```
## [YYYY-MM-DD] ingest | <Source title>
Pages updated: sources/slug.md, projects/X.md, concepts/Y.md
```

### Answer a query

1. Read `index.md` to identify relevant pages.
2. Read those pages.
3. Synthesize an answer with citations (link to wiki pages).
4. If the answer is non-trivial, file it as a new concept or analysis page.
5. Append to `log.md`:
```
## [YYYY-MM-DD] query | <Question summary>
Answer filed: concepts/slug.md (or "inline, not filed")
```

### Lint pass

Check for:
- Orphan pages (no inbound links)
- Stale claims superseded by newer sources
- Concepts mentioned but lacking their own page
- Missing cross-references between related pages
- Gaps in project pages (empty sections)

---

## Durable content, not a process trail

**A wiki page records the current state of knowledge and the reasoning that supports it. It is not a record of how that knowledge was arrived at.** Write pages the way you would write good meeting minutes: not everything that was said, but the claims, the arguments, the decisions, and what is still open.

`log.md` is where chronology belongs. That is what it is for. Keep it out of `concepts/`, `projects/` and `sources/`.

**Do not write, in a wiki page:**

- Session narration: *"Added 2026-07-14"*, *"Resolved in this pass"*, *"the PI asked on Tuesday"*, *"a subagent found"*.
- The page's own revision history: *"an earlier version of this page said X; that was wrong"*. Just say the right thing. If the correction itself is instructive (a tempting argument that does not survive scrutiny), keep **the argument and why it fails**, not the fact that the page once got it wrong.
- Discovery order: *"first we thought X, then we found Y"*. State Y, and state X only if a reader would otherwise re-propose it.
- Numbered review passes, per-session subsections, play-by-play of who said what when.

**Do write:**

- Definitions, claims, and the evidence for them.
- **Positions attributed to people** (*"Reussner's position is containment; Koziolek's is three siblings"*). Who holds a view is durable and often load-bearing. *When they said it* usually is not.
- Decisions **with their rationale and their scope** (what was decided, why, what it does not cover, what it depends on).
- Open questions, and what would settle them.
- Dates only where the date is itself content: a deadline, a publication year, a dated snapshot in `sources/`, a decision whose validity is time-bounded.

**Source pages are the one partial exception.** A `sources/` page is a dated snapshot of one artefact, so its `date:` and its *(Source: German)*-style provenance stay. But even there, record the **positions and arguments**, not a message-by-message replay of the thread. A transcript is not minutes.

**Test before you write a sentence:** *would this still be worth reading by someone who was not here, six months from now?* If it only makes sense as a report of what happened in a session, it belongs in `log.md` or nowhere.

**When revising a page, prune.** A page that has accumulated a process trail should be rewritten to keep only durable content, dropping the narration around how each fact was found. No claim, citation or open question may be lost in the process; only the story of how it got there.

## Operational knowledge goes in the memory store, not in the wiki

`vault/wiki/` holds research knowledge. How an agent should work on it, and the corrections it has needed, go to the project's memory store (`.claude/memory/`, one file per fact, indexed by `MEMORY.md`), never into a wiki page. The store is reached through `MEMORY.md` and through skills, and is not loaded wholesale into a working session. Before writing to the store or changing its format, read [`llm-wiki-instructions/memory-store.md`](memory-store.md), which has the four format rules (index line as the product, short pattern pages, patch instead of duplicate, document what worked) and the evidence behind them.

## Source discipline

The full rules, with their reasons, are in [`llm-wiki-instructions/literature-handling.md`](literature-handling.md). Read it before ingesting a source, filing or fetching a paper, or handling deep-research output. In short:

- **Source pages are dated snapshots.** Do not revise a `sources/` page to reflect newer knowledge; reconcile in project and concept pages.
- **No claims about an artifact you have not opened** in this session. A filename or someone's description is not the content.
- **The source page is the read-receipt.** A PDF on disk does not mean it was read, and a PDF absent from disk does not mean it was not. Without a source page, the statement is "no LLM-wiki-agent has read this".
- **A paper dropped in an inbox is filed by the agent:** confirm its identity, rename, move to `literature/`, extract, read, write the source page.
- **Version the derived artefact,** not an original that is durably held elsewhere (paper PDFs, e-mail).
- **Never hand a fetch back to the user without a link:** DOI link plus a Google Scholar search URL for every item.
- **Deep research is not a read.** Every paper-content claim from it is `⚠️ UNVERIFIED` until a source page records a primary read.

---

## Conventions

- All wiki pages are in English. So is all other new text that goes to a shared Git host (GitLab, GitHub): READMEs, `CLAUDE.md` files, notes, logs, commit messages, issues and merge-request descriptions, so that colleagues who read only English can follow it. A project's own `CLAUDE.md` may name exceptions, such as course material written for German-speaking students. Quotes from sources in another language stay in that language, with a short English gloss where the meaning is not obvious.
- Internal links are standard Markdown links with a path relative to the linking page and the `.md` extension written out: `[VSUM](../concepts/VSUM.md)` on a page in `sources/`, `[open questions](A03.md#open-questions)` between two pages in `projects/`. Obsidian, GitLab, GitHub and the VS Code preview all resolve this form, and Obsidian counts it for backlinks, the graph view and rename updates. Do not write `[[WikiLink]]` links in new text, since only Obsidian renders them. Do not write paths from the wiki root (`concepts/x.md` on a page in `sources/`) either. Obsidian accepts them, and GitLab and VS Code do not.
  - **Heading anchors** are the heading's GitLab slug: lowercase, punctuation dropped, spaces turned into hyphens, runs of hyphens squeezed to one. GitLab and VS Code jump to the heading. Obsidian matches an anchor against the heading text and otherwise opens the page at the top, so an anchor jumps everywhere only where slug and text agree (`### p5-4`). Do not give a heading an explicit `{#id}`. No renderer honours it, so it is printed with the heading and becomes part of the slug.
  - **Spaces** in a path are written `%20`. Avoid them in new file names.
  - **YAML frontmatter** holds no links. A Markdown link there is a plain string in every renderer, and a value starting with `[` parses as a YAML list. Name the page in prose or as a backticked path.
  - **Obsidian settings** (Settings, Files and links): turn off *Use [[Wikilinks]]*, set *New link format* to *Relative path to file*, and keep *Automatically update internal links* on. Links that Obsidian inserts or rewrites on a rename then take this form.
  - **A wiki that still holds `[[...]]` links** is converted in one scripted pass, committed on its own so that it can be reverted. Until then, leave existing `[[...]]` links as they are.
  - The `[[name]]` links between the files of an agent memory store are a separate mechanism and are not affected.
- Keep `index.md` and `log.md` always up to date.
- When a source is in another language, note `(Source: <language>)` in the source page.
- For PDFs in raw-source directories, note the file path as the source reference.
- Date format: ISO 8601 (`YYYY-MM-DD`).
- Be concise in source pages; be thorough in project and concept pages.
- Do not use em-dashes (—) or en-dashes (–). Use commas, periods, parentheses, or colons instead. This applies to wiki content, drafted emails, and conversational replies.
- No AI fluff. Use plain technical prose. Avoid AI-style emphasis and superfluous adjectives such as "key", "critical", "central", "core", "important", "major", "genuine", or "novel" unless they add specific, defensible meaning. Prefer neutral labels like "research question", "people", "pain points", "techniques", and "references". Also avoid hedging filler ("it's worth noting that..."), preamble ("great question..."), and trailing summaries that restate what was just said.

For evolving project- or user-specific conventions, also read `vault/wiki/conventions.md`.

---

## Quality bar

This wiki supports research work that will be reviewed by domain experts. Treat every claim as something a knowledgeable reviewer might challenge.

- **Every claim must be defensible.** If a statement says "no existing approach does X", that claim must survive scrutiny by an expert who knows the field. Hedge appropriately ("to the best of our knowledge", "in the surveyed literature").
- **Novelty must be precisely scoped.** Don't claim too broadly. State *exactly* what combination is novel and acknowledge what parts already exist.
- **Related work must be thorough.** Missing a key related work is a fatal flaw in expert review. When in doubt, add it with a note to verify.
- **Terminology must be precise.** Avoid vague or overloaded terms (e.g., don't use "semantic" unless mapping to a formal system). Define terms explicitly.

---

## Citation and reference conventions

### Citation keys (bibtex-style)

> **These keys are for the wiki only.** If the project has a reference manager (Zotero, Mendeley) that generates the keys used in the actual `.bib` and `\cite`s, **its convention wins for anything that leaves the wiki**. The wiki keys are an internal index and need not match. Check the project's own rules before emitting a BibTeX block or writing a `\cite`; carrying the wiki convention into a bibliography produces keys that do not resolve.

Use **authorYEARword** citation keys throughout the wiki, following Google Scholar conventions:

- Format: `[firstAuthorLastName][YEAR][first-meaningful-word-of-title]`
- Examples:
  - `ananieva2022conceptual` — Ananieva et al., "A conceptual model for unifying variability…", EMSE 2022
  - `dai2024ensuring` — Dai et al., "Ensuring privacy…", 2024
  - `weber2023topology` — Weber et al., "Topology-preserving…", 2023
- In running text, cite as: `[ananieva2022conceptual]` or `(see [ananieva2022conceptual], [weber2023topology])`
- Every concept and project page must have a `## References` section at the bottom listing all cited works with their full bibliographic details (as far as known).

### References section format

```markdown
## References

- **[ananieva2022conceptual]** S. Ananieva, S. Greiner, T. Kehrer, J. Krüger, et al. — *"A conceptual model for unifying variability in space and time"* — Empirical Software Engineering, 2022, Springer. **⚠️ UNVERIFIED**
```

### Verification status

Every reference must carry one of these tags:
- *(no tag)* — verified against the actual publication
- **⚠️ UNVERIFIED** — cited from deep research, meeting notes, or memory; not yet confirmed against the actual publication
- **⚠️ DETAILS INCOMPLETE** — key verified but bibliographic details (year, venue, exact title) need completion

All claims and references sourced from LLM deep research, meeting notes, or LLM synthesis must eventually be confirmed by a manual literature check. Deep research can hallucinate references or misattribute findings. Before any external submission, every `⚠️ UNVERIFIED` tag must be resolved.

### Bibliographic verification: OpenAlex first, DBLP second

Verify the bibliographic record (title, authors, year, venue, DOI) before recording a citation: OpenAlex first, DBLP second, `⚠️ UNVERIFIED` when neither resolves it. This confirms the record, not that the paper supports the claim. The API calls and fields to extract are in [`llm-wiki-instructions/literature-handling.md`](literature-handling.md), section "Bibliographic verification".

---

## PDF text extraction

The dev container ships with `pdftotext` (poppler-utils). To extract text from a PDF:

```bash
pdftotext 'path/to/paper.pdf' 'path/to/paper.txt'
```

Place the `.txt` file next to the source PDF with the same base name. These are derived files (typically gitignored) that can be regenerated.

---

## Git hygiene (submodules)

If the project uses git submodules, read [`llm-wiki-instructions/git-submodules.md`](git-submodules.md) at session start and before committing in the outer repo: it covers syncing submodules, installing the pre-commit hook, auditing submodule pointer changes, and not committing from Claude Cowork.
