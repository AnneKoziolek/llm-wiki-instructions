# LLM Wiki — How to Use

> Quick reference for coming back after a break. Full schema in `CLAUDE.md` (this folder, or wherever it is imported into the project's root `CLAUDE.md`).

## What this is

An LLM-maintained wiki for a research project, based on
[Andrej Karpathy's LLM wiki pattern](karpathy-llm-wiki.md).

- **You** add raw notes to the project's raw-source directories and ask questions
- **The LLM** reads, synthesizes, and maintains `vault/wiki/`
- **Obsidian** shows you the graph; **VS Code + Claude Code** is the editing environment

## File layout (per project)

```
<project-root>/
├── CLAUDE.md                  ← Project instructions; imports llm-wiki-instructions/CLAUDE.md
├── llm-wiki-instructions/     ← This folder (shared across projects)
├── vault/
│   └── wiki/                  ← LLM-maintained
│       ├── index.md           ← Start here when querying
│       ├── log.md             ← What was ingested and when
│       ├── overview.md        ← Evolving project synthesis
│       ├── conventions.md     ← Project-specific evolving conventions
│       ├── projects/          ← Sub-project / workstream pages
│       └── concepts/          ← Concept pages
└── <raw-source-dirs>/         ← Read-only inputs (notes, PDFs)
```

## Typical commands to give Claude Code

### Ingest a single note
```
Ingest <path-to-raw-source-file>
```

### Ingest a batch
```
Ingest all <topic> meeting notes from <raw-source-dir>
```

### Ingest a paper
```
Ingest <path-to-pdf> for <project-id>
```

### Query the wiki
```
Query: what are the main open questions for the <project-id> section?
Query: summarize what we know about <topic> across all sub-projects
Query: what decisions were made in the last three <project-id> meetings?
```

### Lint / health-check
```
Lint the wiki — find orphan pages, stale claims, missing cross-references
```

### Update a project page manually
```
Update projects/<id>.md with the new evaluation methodology we discussed
```

## What happens on each ingest

1. Source page created in `wiki/sources/`
2. Relevant project pages (`wiki/projects/`) updated
3. Concept pages created or updated (`wiki/concepts/`)
4. `wiki/index.md` updated
5. Entry appended to `wiki/log.md`

## Tips

- **Read `index.md` first** when you return — it's the map of everything ingested so far
- **Check `log.md`** to see what was done in your last session (`grep "^## \[" vault/wiki/log.md | tail -10`)
- **Good answers get filed** — ask the LLM to save a useful synthesis as a new concept page
- **Run a lint pass** every few sessions to keep the wiki healthy
- The wiki is just markdown files in git — you get version history for free
