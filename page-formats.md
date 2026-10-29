# LLM Wiki: page formats

Templates for the page types in `vault/wiki/`. Read this file before creating a page, or when auditing a page's sections (`/wiki-lint`). Referenced from `CLAUDE.md`, section "Page formats".

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

### Paper page (`papers/<slug>.md`)

For a paper the project is writing itself. Slug `<year>-<venue>-<topic>`.

```markdown
---
type: paper
tags: [paper]
venue: <venue + track>
deadline: YYYY-MM-DD
status: drafting | internal-review | submitted | under-review | revision-in-progress | camera-ready | published
---
# <slug>: <working title>

## Status
<!-- Cold-start block: phase, what to read first in reading order, open decisions. -->
## Claim
<!-- One sentence: what the paper asserts that was not known before. -->
## Contributions
<!-- The numbered list the introduction's contribution paragraph has to match. -->
## Structure state
## Related work coverage
## Evidence map
<!-- Each claimed number, and the artefact it comes from. -->
## Open questions
## Review rounds
## People
## Related concepts
## References
## Sources
<!-- What has actually been read of the manuscript, and what has not. -->
```

Two sections do work the other page types do not, and both exist because a paper
is a *deliverable* rather than a body of knowledge:

- **`## Evidence map`** ties every number the paper claims to the artefact it
  came from (a test assertion, a results CSV, a measurement log, a table in the
  submitted PDF). A number in a planning note or an earlier draft is not a
  result. This is the page's defence against a fluent sentence about a
  measurement nobody made, and it matters most where the agent is allowed to
  generate prose.
- **`## Sources`** records how far the manuscript has actually been read, section
  by section if need be. A paper page is written while most of the paper is
  still unread, so the read scope has to be explicit or the page's silence gets
  mistaken for coverage.

The cold-start content (status, what to read first, open decisions) belongs here
and not in the project's `CLAUDE.md`, where it goes stale unread. Chronology
belongs in `log.md`, per the durable-content rule.

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

