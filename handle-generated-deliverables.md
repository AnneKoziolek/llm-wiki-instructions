# Handling generated deliverables (do not clobber user edits)

Applies whenever you create or overwrite a file the user can open and edit outside the
session: presentations (.pptx), documents (.docx), spreadsheets (.xlsx), PDFs, and any
other generated deliverable. It applies no matter how you write the file: the Write or
Edit tools, or a shell command such as `cp`, `>`, `tee`, or a build script that emits it.

The short pointer that brings you here lives at
`.claude/rules/mcse-rules/handle-generated-deliverables.md` (auto-loaded into every
session); this file is the full procedure, read on demand.

## The problem

Between your turns, and between sessions, the user may edit a file you produced (for
example, adjusting wording on a slide you built). If you then regenerate that file from
your own earlier draft, a template, or a scratch copy and overwrite it, the user's edits
are gone with no diff and no warning. A stale-but-correct file is recoverable; a silently
clobbered one usually is not.

## Procedure

Before writing or overwriting an existing deliverable:

1. Establish the current state of the file on disk. Read it, or compare its modification
   time or a hash to the version you last read or wrote this session.
2. Unchanged since you last saw it: proceed.
3. Changed: assume the user edited it. Do not overwrite. Re-read the current file, then
   - if your change and the user's edits touch different, non-overlapping parts and the
     merge is clean and unambiguous, apply your change on top of the current file; or
   - otherwise stop and ask the user how to reconcile, showing what differs.

Always build the new version from the current file on disk. Never rebuild it from an
earlier base, a template, or a scratch or intermediate copy: that discards the user's
edits even when you skip the check above.

## Prefer non-destructive output

When you are unsure, or the change is large, write a new versioned filename (for example
`deck_v2.pptx`) rather than overwriting, and state which file you used as the base so the
user can catch a stale-base mistake before it costs them work.

## No automated enforcement

Nothing blocks a clobbering write for you. There is no hook or tool gate, on any surface,
so this discipline is entirely your responsibility, for every write mechanism (the Write
and Edit tools and shell writes alike). Do not assume something will stop you: check the
current file before you overwrite it.

## Why this file is separate

Keeping the detail here, read on demand, rather than in the always-loaded pointer rule,
keeps the per-conversation context cost to the one short pointer while still giving you
the full procedure the moment you are about to generate a file.
