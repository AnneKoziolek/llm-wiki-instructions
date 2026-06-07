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
| `hooks/pre-commit` | Optional git pre-commit hook for the **parent** repo: warns when a commit changes a submodule pointer in a way that looks unintentional (silent rollback, uninitialised submodule, staged SHA != submodule's local `HEAD`). See "Git hygiene (submodules)" in `CLAUDE.md`. |
| `install-hooks.sh` | Installer that symlinks each file in `hooks/` into the parent repo's `.git/hooks/`. Run once per clone, from the parent repo root: `bash llm-wiki-instructions/install-hooks.sh`. |

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
5. (Recommended) Install the submodule-safety pre-commit hook into
   the parent repo: `bash llm-wiki-instructions/install-hooks.sh`.
   This is per-clone (the parent repo's `.git/hooks/` is not
   versioned), so every contributor and every CI runner that
   commits back has to run it once. See "Git hygiene (submodules)"
   in `CLAUDE.md` for what the hook catches.

## Updating an existing wiki to a newer `llm-wiki-instructions`

When this submodule gains a new commit (e.g. the hook changes, or
the schema gets a new section), each wiki that consumes it needs to
be bumped. From the parent repo's root:

```bash
git -C llm-wiki-instructions pull
git add llm-wiki-instructions
git commit -m "Bump llm-wiki-instructions"
bash llm-wiki-instructions/install-hooks.sh   # re-run per clone
```

The `install-hooks.sh` line is idempotent: if the symlink is
already in place and pointing at the same `hooks/` directory,
it prints `[ok]` and exits 0. If the hook is absent (fresh clone,
new dev container), it installs it. If a different non-symlink
hook is in the way, the script skips that name and tells you to
re-run with `--force` (which backs up the existing file).

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
