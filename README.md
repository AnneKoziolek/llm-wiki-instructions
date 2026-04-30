# LLM-Wiki Instructions

A reusable schema and workflow for an LLM-maintained research wiki, modelled on
Andrej Karpathy's LLM-wiki pattern (see `karpathy-llm-wiki.md`).

## What this is

A small set of instruction files that define **how an LLM should maintain a
markdown research wiki** for a long-running project (proposal, thesis, group
knowledge base, etc.):

| File | Purpose |
|------|---------|
| `CLAUDE.md` | The schema + workflow (page formats, ingest/query/lint operations, citation conventions, quality bar). This is what an agent like Claude Code reads as project instructions. |
| `HOW-TO-USE.md` | Human-facing quick reference: how to talk to the agent, common commands, where to look. |
| `conventions.md` | Project-specific conventions that evolve over time (terminology, authorship, ingest preferences). Lives **inside** the wiki vault, not here — this folder ships only an empty template. |
| `karpathy-llm-wiki.md` | Reference: the pattern this is based on. |

## How to use it in a new project

1. Drop this folder into the new project (as a sibling, submodule, subtree,
   or a copy — see the parent project's README for how it is wired in).
2. Either copy `CLAUDE.md` to the project root, or have the project's own
   `CLAUDE.md` pull it in via the `@` import syntax (see "Importing into
   CLAUDE.md" below).
3. Customize the **project-specific placeholders** in `CLAUDE.md`
   (`<<PROJECT_NAME>>`, the sub-project table, the in-scope concepts list,
   the raw-source paths). The schema sections (page formats, operations,
   citation conventions, quality bar, PDF extraction) should stay as-is.
4. Create `vault/wiki/conventions.md` in the new project from the template
   here — it will accumulate project-specific conventions as you work.

## Importing into CLAUDE.md

Claude Code's `CLAUDE.md` supports importing other files via the `@path`
syntax. So the project's root `CLAUDE.md` can be as small as:

```markdown
# <<PROJECT_NAME>> Wiki

@llm-wiki-instructions/CLAUDE.md

## Project context

<<project-specific table of sub-projects, in-scope concepts, raw-source paths>>
```

This keeps the reusable schema in one place and the project-specific bits
local to the project.

## What does *not* go in this folder

- Anything project-specific (sub-project lists, deadlines, people, file
  paths into the project tree). Those belong in the project's own
  `CLAUDE.md` or in `vault/wiki/conventions.md`.
- Wiki content itself — this folder defines the schema, not the data.
