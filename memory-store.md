# LLM Wiki: operational knowledge and the memory store

Read this file before writing to, or changing the format of, the agent memory store (`.claude/memory/` in projects that have one). The rule in one line stays in `CLAUDE.md`.

## Operational knowledge goes in the memory store, not in the wiki

`vault/wiki/` holds research knowledge. **How an agent should work on it**, and
the corrections it has needed, go to `/workspace/.claude/memory/`: one file per
fact, indexed by `MEMORY.md`, with `skill-impact.md` recording every skill change
and every proposal the PI refused. That directory's `README.md` carries the
format; `shared/reference-wikiskill.md` carries the argument and the source.

The split is load-bearing, not tidy-mindedness. Tooling is not research
knowledge, and three copies of anything drift. It also has an empirical argument
behind it: WikiSkill (arXiv:2608.27454v1) ablated exactly this and found that an
agent carrying the operational store while *doing the task* performed worse than
one carrying only its skills, because it then solves from the store instead of
from the skill and the trace stops showing what the skill fails to cover. So the
memory store is reached through `MEMORY.md` and through skills, and is never
loaded wholesale into a working session. `/skill-evolve` is the separate pass
that maintains it.

Four format rules come from the same source and apply to any page whose job is
to be found and acted on.

**An index line is the product; the page is only read if the line earns it.**
WikiSkill's own maintainer prompt calls the index "the MOST IMPORTANT part of the
wiki" and mandates `[name](path): PROBLEM + ROOT CAUSE + FIX in one or two
sentences`. In `MEMORY.md` that form is binding, soft cap 350 characters. In
`vault/wiki/index.md` the entries catalogue research pages rather than failure
modes, so the weaker version applies: a line has to let a reader judge relevance
without opening the page, which a restated title does not. The same reasoning
already governs the `description:` frontmatter of a `SKILL.md`, which is what
Claude Code matches against.

**A page whose job is one pattern stays at 10 to 30 lines, "not essays".** The
skills WikiSkill measured came out at 45 to 143 markdown lines and its pattern
pages at 18 to 48. A 200-line skill carrying a 60-line worked precedent is two
artefacts: the procedure belongs in the skill, the observed failure modes and the
PI's rulings belong in the memory store. Split it when you next touch it.

**Patch; do not rewrite; never duplicate.** A recurrence is appended as evidence
to the existing page, so that a rule observed five times is visibly stronger than
one observed once. Creating a second page on the same failure mode destroys that
signal, and it is the main thing to check before creating anything.

**Document what worked, not only what broke.** A store of failures alone cannot
tell you which existing guidance is already doing its job and must be left alone.
