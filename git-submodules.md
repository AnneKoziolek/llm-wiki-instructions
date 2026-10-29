# LLM Wiki: git hygiene for submodules

Needed only in projects that use git submodules (this instructions submodule, rules, skills, Overleaf mirrors). Read it at session start and before committing in the outer repo. Setup per clone is also described in `README.md`.

## Git hygiene (submodules)

LLM wikis built on this schema typically pull in several git submodules: this instructions submodule (`llm-wiki-instructions`), the rules submodule (`.claude/rules/mcse-rules`), a project-scoped skills submodule (`.claude/skills`), and any proposal-text submodules (Overleaf mirrors). Two recurring failure modes are worth guarding against:

1. **Working with stale submodule contents** because a submodule was never initialised on the current machine (or was initialised once and has drifted), so files read inside it are old or absent.
2. **Silently committing a rollback** of a submodule pointer in the outer repo, because the working tree had the submodule at an older SHA than the outer commit recorded. The committer notices weeks later when a colleague's machine produces a merge conflict on the gitlink.

### Do not commit from Claude Cowork (sandboxed environment)

Claude Cowork works on this repo from a sandbox where history-writing git is unreliable: committing and submodule operations fail there (observed: submodule `index.lock` "Operation not permitted" errors under `.git/modules/`, and partial or refused writes). From Cowork, do not run `git commit`, `git add`, `git rm`, `git mv`, or any command that writes history or the index. Create and edit files only, and leave staging, committing, and the submodule-pointer audit below to the user on a normal checkout (Claude Code CLI, VS Code, or a terminal). Read-only inspection (`git status`, `git diff`, `git diff --submodule=log`) is fine and is the right way for a Cowork session to report what it changed. This does not relax the audit rules below; it defers them to whoever performs the commit.

### At session start, sync submodules

The first non-trivial action in a new session, and again whenever a session resumes after a meaningful gap (overnight, after a long pause, after switching branches), is:

```bash
git submodule update --init --recursive
```

Run this from the outer repo root. It initialises any submodule that is not yet checked out and snaps each submodule's working tree to the SHA the outer repo currently records. This is read-only against the submodule's history (no commits) but does discard uncommitted work inside a submodule, so check `git status` in each submodule first if you have unfinished local work.

The `git pull` you run in the outer repo does **not** update submodules by default; do not assume it does. Either configure `git config submodule.recurse true` once, or invoke the explicit command above.

### One-time per clone: install the pre-commit hook

`.git/hooks/` is not versioned, so the hook must be installed once per clone (fresh contributor clone, new dev container, new CI runner that commits back). Run from the outer repo root:

```bash
bash llm-wiki-instructions/install-hooks.sh
```

This creates a relative-path symlink at `.git/hooks/pre-commit` pointing into the submodule. The script is idempotent (re-running is a no-op if the symlink is already correct) and refuses to clobber an existing non-symlink hook unless `--force` (which also backs up the original).

An agent finding `.git/hooks/pre-commit` absent or pointing somewhere else should install it before producing any outer-repo commits. Quick check:

```bash
ls -l .git/hooks/pre-commit 2>/dev/null | grep -F 'llm-wiki-instructions/hooks/pre-commit' \
  || bash llm-wiki-instructions/install-hooks.sh
```

When the `llm-wiki-instructions` submodule pointer is bumped past a commit that changes anything under `hooks/`, re-run the install command in each clone (the symlink target itself is stable, but re-running surfaces drift to the next maintainer).

### Before committing in the outer repo, audit submodule pointer changes

Whenever `git status` in the outer repo lists a submodule under "Changes to be committed" or "Changes not staged", verify the change is intentional **before** running `git add` / `git commit`:

```bash
git diff --submodule=log <submodule-path>
```

This shows the submodule commits that the pointer change would land on. Two checks:

- The new SHA should be **forward** from the old SHA (the listed commits are real new work, not an empty list or a "reverse" arrow).
- The new SHA should match what you actually intend, i.e. the submodule's current `HEAD` (`git -C <submodule-path> rev-parse HEAD`). If the submodule is uninitialised or stuck on an old SHA, the staged pointer is whatever the working tree happens to show, which is rarely what you want.

If the change is unintentional:

- To snap the submodule back to the recorded SHA and unstage: `git submodule update <path>` (followed by `git reset HEAD <path>` if you had already staged the change).
- To advance the recorded pointer to the submodule's actual `HEAD`: `git add <path>` after first making sure the submodule's `HEAD` is what you want (pull / fetch / checkout inside the submodule).

The `llm-wiki-instructions/hooks/pre-commit` hook (install with `bash llm-wiki-instructions/install-hooks.sh` from the outer repo root) automates the same check at commit time and prompts before letting a suspicious change through.
