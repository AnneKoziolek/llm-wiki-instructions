# LLM Wiki: handling sources and literature

Read this file before ingesting a source, filing or fetching a paper, handling deep-research output, or adding a reference to the wiki or a `.bib` file. `CLAUDE.md` keeps a short summary of the rules below; this file has the full text and the reasons.

## Source discipline

**Source pages are dated snapshots.** A `sources/` page records what its source said at the time of ingestion. Do not revise it later to reflect newer knowledge — the living synthesis (`projects/`, `concepts/`, `overview.md`) is where contradictions are reconciled and the current understanding lives. When a later source supersedes it, record that in the project/concept page, or add a dated annotation to the source page; do not rewrite the snapshot. Editing a source page for fidelity (typos, broken links, citation fixes, cross-links) is fine.

**No claims about an artifact you have not opened.** Do not describe, summarize, paraphrase, "mirror", reproduce, or build on the content of any artifact — paper, slide, document, attachment, image, spreadsheet, email, link, dataset — that you have not opened/read in this session. A filename, path, reference, or someone else's description is not the content, even when a task says to "mirror" or "be consistent with" it. Instead: state plainly that you do not have it, ask the user to provide it, and offer a path that does not require it (e.g., a standalone draft from known facts, clearly marked as not derived from the unseen artifact). If you must reference it unopened, attribute the statement to the secondary source ("per the email, the slide is titled X") and mark it unverified/unseen. Bibliographic verification of a paper (DOI / venue / authors) does not count as reading it.

### The source page is the read-receipt. A PDF on disk is not, and a PDF absent from disk means nothing.

**A `sources/` page is the only evidence that an LLM-wiki-agent has read a work.** Use it, and nothing else, to decide whether a paper-content claim in the wiki rests on a primary read.

The two failure modes, in both directions:

- **Absent PDF does not mean unread.** The PI reads on several machines, from institutional access, from print, and from her own library. The `literature/` folders in this repo are a convenience cache, not a record of what has been read. **Never write or imply that the PI has not read something because the file is not in the repo.** She may know the paper far better than the wiki does.
- **Present PDF does not mean read.** A PDF can be fetched for one sub-project, sit on disk for months, and never be opened by any agent. (Burgueño MODELS 2018 sat in `c04/literature/` from 2026-05-25 while A03 pages made unverified claims about its contents.) A `.txt` extraction next to it proves `pdftotext` ran, nothing more.

So: **presence on disk is evidence about the filesystem; a `sources/` page is evidence about knowledge.** When auditing whether a claim is backed by a read, look for the source page. When there is none, the correct statement is *"no LLM-wiki-agent has read this"*, never *"this has not been read"*.

A source page asserting a read must say so explicitly and say how far it went: **Verified YYYY-MM-DD** by reading the PDF end-to-end / by reading Sections X-Y / by skimming. Anything less specific is not a read-receipt.

### When the PI drops a paper in an inbox, rename it, move it, and read it.

The PI fetches the papers an agent cannot (paywalls, CAPTCHAs, institutional logins) and drops them in a scratch/inbox folder, under whatever name the publisher gave them (`burgueno 3542947.pdf`, `download.pdf`, `1-s2.0-S....pdf`). **Filing them is the agent's job, not hers.** Do not leave a paper sitting in the inbox, and do not read it in place: an unfiled PDF under a publisher's opaque filename is invisible to the next session.

On finding a dropped paper:

1. **Open it and confirm what it is** before anything else. The filename is not the identity, and the PI may have grabbed the wrong record. Check title and authors against the reference that was requested.
2. **Rename** to the project convention: `firstauthorYEAR-short-title.pdf` (`burgueno2023-dealing-belief-uncertainty-domain-models.pdf`). Match the style already used in the destination folder rather than inventing a new one.
3. **Move** it into the relevant sub-project's `literature/` directory, in the subfolder that groups the topic if one exists.
4. **Extract** the text next to it: `pdftotext <file>.pdf <file>.txt`.
5. **Read it, and file a `sources/` page.** A filed PDF with no source page is still an unread paper (see the read-receipt rule above). The point of the fetch was the read.
6. **Leave the inbox clean** of that file, and do not touch anything else in it.

Do not ask the PI where to put it or what to call it. She dropped it precisely so she would not have to think about that.

### Version the derived artefact, not an original that is already persisted elsewhere.

**If an artefact is durably held outside this repository, do not commit it. Commit what the repository adds to it: the extraction, the source page, the synthesis.**

Apply the test once, before committing an ingested original, rather than deciding it again per file type:

- **Held elsewhere, so not versioned:** paper PDFs (publisher, DOI, the PI's own library), e-mail (the mail store), slide decks and saved web pages whose source still resolves, deep-research `.docx` (regenerable), documents circulated under embargo.
- **Versioned, because this repository holds the only copy:** meeting transcripts and the notes taken in the meeting, `pdftotext` and `docx2txt` extractions, and everything in `vault/wiki/`. A transcript of a discussion that cannot be repeated has no other home, which is exactly why it is committed while the PDFs beside it are not.

Two reasons, and the second is the one that gets forgotten. A second copy of something unlosable is pure cost, in clone size and in review noise. And a repository with a backup remote **publishes** what it commits: an embargoed draft, a private mail address or a paywalled PDF committed here reaches every mirror and stays in the history after deletion. Confidentiality and licensing are settled **before** the first commit, not by a later `git rm`.

Where the call is genuinely close it belongs to the PI, and the ingest tracker records which way it went and why. Do not re-open it per artefact.

### Never ask the PI to fetch a paper without giving her a link.

When a fetch fails and the work is handed back to the PI, **every single item must carry a resolvable URL, printed as bare plain text.**.

For each unfetched item, give:

- the **DOI link** (`https://doi.org/<DOI>`) whenever a DOI resolved;
- a **Google Scholar search URL** (`https://scholar.google.de/scholar?q=<encoded>&btnG=`) always, including when a DOI exists, because Scholar surfaces preprint and repository mirrors the publisher page hides;
- any **open-access or repository mirror** found (institutional repository, arXiv, author-hosted PDF), even one the container could not fetch: a CAPTCHA or a login wall stops an agent, not a human with a browser and institutional access;
- one clause on **why it is blocked** (ACM Cloudflare, closed access, CAPTCHA-gated repository), so the PI knows whether to expect a paywall.

**Print URLs bare, never as Markdown `[label](url)`.** The PI's VSCode chat does not render Markdown links as clickable, so a wrapped link is unreachable. (This applies to chat replies. Inside `vault/wiki/**`, which is read in Obsidian, Markdown links are fine and remain the convention.)

If no DOI and no mirror could be resolved at all, say so explicitly and still emit the Scholar URL. A failed lookup is itself worth reporting: a reference that resolves in neither OpenAlex nor DBLP is often a **deep-research phantom**, and the right next step is to doubt the reference, not to hunt harder for it.

### Deep research is not a read. Mark everything it returns `⚠️ UNVERIFIED`.

Deep-research runs (claude.ai Research mode, Deep Research, or any external LLM search-and-synthesise tool) **do not operate under these instructions.** They have never seen the literature-handling rules, they are not obliged to distinguish a primary read from a secondary characterisation, and they routinely state a paper's contents in confident primary-voice prose whether or not the paper was opened. Their output may be right; it may be a summary of an abstract; it may be a hallucination. **From the wiki's side these are indistinguishable.**

Therefore:

- **Every paper-content claim originating from a deep-research run is `⚠️ UNVERIFIED` on arrival**, regardless of how specific, confident, or plausible it is. Specificity is not evidence: a run that says *"§5.3 explicitly leaves confidence per alternative as future work"* has not thereby demonstrated that it read §5.3.
- The tag means exactly *maybe read, maybe not, nobody knows*. It is not an accusation and not a rejection. It is a statement about what the wiki can currently vouch for.
- **The tag is cleared only by a source page recording a primary read.** Not by the claim being repeated on another page, not by it surviving several review cycles, not by a bibliographic lookup confirming the DOI. Bibliographic verification and content verification are independent axes (see `⚠️ UNVERIFIED` vs `⚠️ UNREAD` in the rules submodule).
- **Section-, footnote-, and quote-level claims from deep research are the highest-risk category** and must never be carried into external-facing text unread. An instruction like *"quote §5.3 verbatim"* attached to a paper with no source page is a trap: it invites an author to put a fabricated quotation in front of a reviewer. Either read the paper and record the real quote, or drop the instruction.
- When a deep-research claim is **promoted into a project or concept page**, carry the tag with it. A claim does not launder itself by being restated in the project's own voice.

The cost asymmetry is the whole argument: reading the paper costs an hour; a confident-but-wrong characterisation of a reviewer's own field, in a proposal, is unrecoverable.


## Bibliographic verification: OpenAlex first, DBLP second

When adding a reference to a wiki page, a deep-research source page, or a proposal `.bib` file, **verify the bibliographic record before recording the citation**. Verification only confirms that the bibliographic details are correct (title, authors, year, venue, DOI); it does not confirm that the paper supports the claim being made. The writer still has to read the paper.

Use this two-step lookup order:

1. **OpenAlex first**. The API is open, returns rich JSON, and covers most journal and conference papers across all fields. Hit one of:
   - Title-based search: `https://api.openalex.org/works?search=<keywords>&per-page=3`
   - DOI lookup (most reliable when the DOI is known): `https://api.openalex.org/works/https://doi.org/<DOI>`
   Parse with `jq` (the dev container has `jq`; Python is not always available). Extract `display_name`, `publication_year`, `(primary_location).source.display_name`, `doi`, `authorships[].author.display_name`, and `biblio.{volume,issue,first_page,last_page}`.

2. **DBLP second**, when OpenAlex returns nothing or returns confusable results. DBLP covers computer-science venues that OpenAlex sometimes misses (workshops, technical bulletins, German `Autom.` journal, ISGT EUROPE workshops). The API is at `https://dblp.org/search/publ/api?q=<query>&format=json&h=5`. Extract from `result.hits.hit[].info`: `title`, `year`, `venue` (or `journal`), `doi`, `pages`, and `authors.author[]`.

If neither service returns a confident result, the reference is typically (a) a book, (b) a technical standard (IEC, ENTSO-E), (c) a vendor specification (DNV OSP-IS), or (d) grey literature (technical reports). In that case, record the reference as **⚠️ UNVERIFIED** with a comment pointing at the publisher page where the writer should locate the bibtex record by hand.

When the wiki/proposal references a reference that has *not* been verified through this path, mark it `⚠️ UNVERIFIED` (per "Verification status" in `CLAUDE.md`) until the lookup is completed.

