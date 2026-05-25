# LLM Wiki — Schema & Maintenance Instructions

You are a disciplined wiki maintainer. Your job: read raw notes and literature, extract knowledge, and maintain the wiki at `vault/wiki/`. You write; the user reads. Never modify files in the raw-source directories declared by the project — those are immutable inputs.

> **Project-specific context** (project name, sub-projects/topics, in-scope concepts, deadlines, raw-source paths, people) lives in the project's own `CLAUDE.md` (which imports this file) or in `vault/wiki/conventions.md`. This file is the stable, reusable schema.

---

## Quality-expectation loop (meta-rule)

Whenever the PI and you discuss *how to do something better* (workflow, naming, voice/tense rule, commit discipline, what counts as authorized AI edit, ...), **before continuing the substantive work** reason explicitly about persistence: where does this improvement live now, and will it survive the next session? Pick the smallest mechanism that fits — feedback memory / wiki concept page / CLAUDE.md addition / project-scoped skill in `/workspace/.claude/skills/` — and create it (or propose it and get PI authorization). Detail in `~/.claude/projects/-workspace/memory/feedback_quality_expectation_loop.md`.

## Project-scoped skills

Reusable multi-step procedures live at `/workspace/.claude/skills/<name>/SKILL.md` and are invocable as `/<name>`. To list them at any time: `ls /workspace/.claude/skills/`. Current set:

- `/proposal-section-review` — review one section of a CRC proposal `.tex` file (spelling, grammar, tense, voice, term glosses; commit + push discipline). Worked precedent: `proposal/c04/C04/progressreport.tex` (commits `cafd396..ac4d2ac`).
- `/ingest-source` — ingest one or more related raw artefacts (meeting transcript + notes + email + figure) into the wiki: one or two source pages, project-page update, index + log entries. Drafted by subagent, not yet exercised — first invocation is the precedent.
- `/critical-proposal-review` — critical content review of a sub-project proposal against DFG criteria + the wiki quality bar, filed as a section in `vault/wiki/projects/<id>.md`. Worked precedent: the four `state-and-critical-review-*` sections in `vault/wiki/projects/C04.md`.
- `/proposal-snapshot-diff` — pull the latest Overleaf state and narrate the diff against a prior baseline (typically the commit referenced in the most recent state-and-critical-review section). Worked precedent: the "Diff against ..." subsection inside `state-and-critical-review-2026-05-23` in `vault/wiki/projects/C04.md`.
- `/wiki-lint` — audit `vault/wiki/` for orphans, stale claims, missing concept pages, broken cross-references, empty project-page sections, frontmatter drift, MEMORY.md discipline, index desync, unverified literature, em-/en-dashes. Read-only by default; per-finding triage. Drafted by subagent, not yet exercised — first invocation is the precedent.

The latter four were drafted in subagent runs on 2026-05-24 and are not yet polished from practice. Refine them in place as their workflows recur.

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

## Conventions

- All wiki pages are in English.
- Use `[[WikiLink]]` style for internal links (Obsidian-compatible).
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

When adding a reference to a wiki page, a deep-research source page, or a proposal `.bib` file, **verify the bibliographic record before recording the citation**. Verification only confirms that the bibliographic details are correct (title, authors, year, venue, DOI); it does not confirm that the paper supports the claim being made. The writer still has to read the paper.

Use this two-step lookup order:

1. **OpenAlex first**. The API is open, returns rich JSON, and covers most journal and conference papers across all fields. Hit one of:
   - Title-based search: `https://api.openalex.org/works?search=<keywords>&per-page=3`
   - DOI lookup (most reliable when the DOI is known): `https://api.openalex.org/works/https://doi.org/<DOI>`
   Parse with `jq` (the dev container has `jq`; Python is not always available). Extract `display_name`, `publication_year`, `(primary_location).source.display_name`, `doi`, `authorships[].author.display_name`, and `biblio.{volume,issue,first_page,last_page}`.

2. **DBLP second**, when OpenAlex returns nothing or returns confusable results. DBLP covers computer-science venues that OpenAlex sometimes misses (workshops, technical bulletins, German `Autom.` journal, ISGT EUROPE workshops). The API is at `https://dblp.org/search/publ/api?q=<query>&format=json&h=5`. Extract from `result.hits.hit[].info`: `title`, `year`, `venue` (or `journal`), `doi`, `pages`, and `authors.author[]`.

If neither service returns a confident result, the reference is typically (a) a book, (b) a technical standard (IEC, ENTSO-E), (c) a vendor specification (DNV OSP-IS), or (d) grey literature (technical reports). In that case, record the reference as **⚠️ UNVERIFIED** with a comment pointing at the publisher page where the writer should locate the bibtex record by hand.

When the wiki/proposal references a reference that has *not* been verified through this path, mark it `⚠️ UNVERIFIED` (per the verification-status conventions above) until the lookup is completed.

---

## PDF text extraction

The dev container ships with `pdftotext` (poppler-utils). To extract text from a PDF:

```bash
pdftotext 'path/to/paper.pdf' 'path/to/paper.txt'
```

Place the `.txt` file next to the source PDF with the same base name. These are derived files (typically gitignored) that can be regenerated.
