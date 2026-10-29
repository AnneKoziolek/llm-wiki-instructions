# Migration notes for consuming wikis

Read this after bumping the `llm-wiki-instructions` submodule in a wiki. Newest entry first. Each entry says what moved and what a consuming wiki has to check. Nothing listed here was deleted: every rule still exists, possibly in another file.

## 2026-10-29: `CLAUDE.md` split into an always-loaded core and on-demand files

**Why.** `CLAUDE.md` had grown to 43.8k characters, over Claude Code's 40k warning for a single instructions file, and every character of it was loaded into every session of every wiki. That matters most for models with a small context window (for example KIT-hosted local models). It is now about 15k. The sections that only one kind of task needs moved to sibling files, which an agent reads when `CLAUDE.md` points it there. Material that only some wikis need (git submodule hygiene, the catalogue of one skills repository) moved out of the schema.

**What moved.** Every old heading is still in `CLAUDE.md`, with a short summary or a pointer, so a reference to it by name still resolves in one step.

| Old place in `CLAUDE.md` | Now | What stayed in `CLAUDE.md` |
|---|---|---|
| "Project-scoped skills" (the full skill catalogue with worked precedents) | `.claude/skills/README.md` of `sdq-skills`, section "Worked precedents and status" | a paragraph: skills are found by their `description:`, the catalogue is the skills README |
| "Page formats" (the four page templates) | `page-formats.md` | a pointer |
| "Operational knowledge goes in the memory store, not in the wiki" | `memory-store.md` | the rule in one paragraph |
| "Source discipline" and its five subsections | `literature-handling.md` | a seven-line summary |
| "Bibliographic verification: OpenAlex first, DBLP second" (API calls, fields) | `literature-handling.md` | the rule in two sentences |
| "Git hygiene (submodules)" and its four subsections | `git-submodules.md` | a conditional pointer: read it if the project uses submodules |

Unchanged in `CLAUDE.md`: quality-expectation loop, directory layout, operations, durable content, conventions, quality bar, citation keys, references format, verification status, PDF text extraction.

**What a consuming wiki has to check.**

1. **Bump `.claude/skills` together with this submodule** if the wiki uses `sdq-skills`. Its `fetch-literature`, `ingest-source`, `wiki-lint` and `skill-evolve` now point to the new files. An older skills checkout still works, through the pointers left in `CLAUDE.md`.
2. **Repoint references in the wiki's own files.** Search the project `CLAUDE.md`, `vault/wiki/conventions.md`, any local skills outside the shared submodule, and the memory store for references to the moved sections, for example: `grep -rn "llm-wiki-instructions/CLAUDE.md\|skill catalogue\|Git hygiene\|Page formats\|Source discipline\|Bibliographic verification" CLAUDE.md vault/wiki/conventions.md .claude/ --include=*.md`. A reference to "the skill catalogue in `llm-wiki-instructions/CLAUDE.md`" now goes to `.claude/skills/README.md`.
3. **Projects that use git submodules**: nothing breaks, because `CLAUDE.md` still tells the agent to read `git-submodules.md`. If the project's own `CLAUDE.md` has a Git section, a one-line pointer to `llm-wiki-instructions/git-submodules.md` there is clearer.
4. **Projects that copied `CLAUDE.md` to their root** instead of `@`-importing it: re-copy it, and keep the `llm-wiki-instructions/` folder in the project, because the pointers name files in it.
5. **Do not `@`-import the new files.** An import loads the file into every session, which undoes the split. Name them by path, as `CLAUDE.md` does.
6. **Bare URLs in chat.** The rule that a link handed back to the user is printed bare (some chat surfaces, such as VS Code chat, do not make Markdown links clickable) is now in `literature-handling.md` and only loads with literature work. A wiki whose user wants bare URLs in every chat reply should state that in its own `CLAUDE.md` or memory store.
7. **Check the size.** `wc -c CLAUDE.md llm-wiki-instructions/CLAUDE.md` plus every always-loaded rule file is what each session pays before the first message.
