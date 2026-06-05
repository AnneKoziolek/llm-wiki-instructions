# LLM Wiki — Schema & Maintenance Instructions

You are a disciplined wiki maintainer. Your job: read raw notes and literature, extract knowledge, and maintain the wiki at `vault/wiki/`. You write; the user reads. Never modify files in the raw-source directories declared by the project — those are immutable inputs.

> **Project-specific context** (project name, sub-projects/topics, in-scope concepts, deadlines, raw-source paths, people) lives in the project's own `CLAUDE.md` (which imports this file) or in `vault/wiki/conventions.md`. This file is the stable, reusable schema.

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
└── sources/            ← One page per ingested source (meeting note, paper)
    └── *.md
```

Raw sources (read-only) — listed in the project's own `CLAUDE.md`.

---

## Page formats

### Project page (`projects/<id>.md`)
```markdown
---
type: project
tags: [project]
---
# <id> — <Short title>

## Research question
## Phase 1 results
## Phase 2 direction
## Open questions
## Key people
## Related concepts
<!-- links to concepts/ and other project pages -->
## References
<!-- [authorYEARword] Full bibliographic entry. Tag ⚠️ UNVERIFIED if not checked. -->
## Sources
<!-- links to sources/ pages that informed this page -->
```

### Concept page (`concepts/<concept>.md`)
```markdown
---
type: concept
tags: [concept]
---
# <Concept>

## Definition
## Role in the project
## Open problems / debates
## Related concepts
## References
## Sources
```

### Source page (`sources/<slug>.md`)
```markdown
---
type: source
date: YYYY-MM-DD
source_type: meeting | paper | note
projects: [<id>, <id>]
---
# <Title>

## Summary
## Key decisions / findings
## Open questions raised
## Wiki pages updated
```

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

## Source discipline

**Source pages are dated snapshots.** A `sources/` page records what its source said at the time of ingestion. Do not revise it later to reflect newer knowledge — the living synthesis (`projects/`, `concepts/`, `overview.md`) is where contradictions are reconciled and the current understanding lives. When a later source supersedes it, record that in the project/concept page, or add a dated annotation to the source page; do not rewrite the snapshot. Editing a source page for fidelity (typos, broken links, citation fixes, cross-links) is fine.

**No claims about an artifact you have not opened.** Do not describe, summarize, paraphrase, "mirror", reproduce, or build on the content of any artifact — paper, slide, document, attachment, image, spreadsheet, email, link, dataset — that you have not opened/read in this session. A filename, path, reference, or someone else's description is not the content, even when a task says to "mirror" or "be consistent with" it. Instead: state plainly that you do not have it, ask the user to provide it, and offer a path that does not require it (e.g., a standalone draft from known facts, clearly marked as not derived from the unseen artifact). If you must reference it unopened, attribute the statement to the secondary source ("per the email, the slide is titled X") and mark it unverified/unseen. Bibliographic verification of a paper (DOI / venue / authors) does not count as reading it.

---

## Conventions

- All wiki pages are in English.
- Use `[[WikiLink]]` style for internal links (Obsidian-compatible).
- Keep `index.md` and `log.md` always up to date.
- When a source is in another language, note `(Source: <language>)` in the source page.
- For PDFs in raw-source directories, note the file path as the source reference.
- Date format: ISO 8601 (`YYYY-MM-DD`).
- Be concise in source pages; be thorough in project and concept pages.
- Use plain technical prose. Avoid AI-style emphasis and superfluous adjectives such as "key", "critical", "central", "core", "important", "major", "genuine", or "novel" unless they add specific, defensible meaning. Prefer neutral labels like "research question", "people", "pain points", "techniques", and "references".

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

---

## PDF text extraction

The dev container ships with `pdftotext` (poppler-utils). To extract text from a PDF:

```bash
pdftotext 'path/to/paper.pdf' 'path/to/paper.txt'
```

Place the `.txt` file next to the source PDF with the same base name. These are derived files (typically gitignored) that can be regenerated.
