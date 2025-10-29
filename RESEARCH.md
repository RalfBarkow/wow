# RESEARCH.md

# Research Notes — Narrative Path Splitter

## Minimal Markdown strategy

* We only need **H1 sectioning** (simple, robust).
  Regex sketch: `^#\s+(SPEC|IMPLEMENTATION_PLAN|RESEARCH|WORKLOG)\s*$` (multiline).
* Keep heading case strict initially to avoid accidental captures.

## GT parser plumbing

* Use the **adapter** pattern (class-side `matches:/priority/parse:`).
* Ensure **registration order** so our adapter appears before `GtNullInputParser`.
* Debug path: `FileReference>>gtInputWhyViewOn:` → `GtInputFile>>selectionExplanation`.

## Idempotent writes

* Compare new contents to existing files; write only on diff.

## Future ideas

* Front-matter → metadata (owners, tags).
* Additional targets (e.g., `DECISIONS.md`, `RISKS.md`).
* Round-trip: consolidate from four files back into master (later).

## Literature Landscape & Evidence Map (2025-10-29)

**Buckets.**
- *Formalism & algorithms:* Müller (narrative flows/paths; variants; adaptation pipeline).
- *Path dependency / sequencing:* Howlett & Rayner (policy), Gurr (literary urban studies).
- *Applied domains using “narrative path” phrasing:* Abad et al. (RE task resumption), Tsubonouchi et al. (nursing), Cultur. Narrative Method (education), Zeng et al. (digital humanities).
- *Theory/poetics (Ricoeur line):* Kemp & Rasmussen; related reviews (Rehg).

**Evidence map (feature → refs).**
- Variants + substitution → **Müller** (variant groups; “holes”).
- Narrative vs. semantic ordering; fallbacks → **Müller**; sequencing debates in **Howlett & Rayner**.
- Path dependency (explanatory framing for our fallback design) → **Gurr**, **Howlett & Rayner**.
- Pedagogical/UX support for walkthrough flow → **Abad et al.**, **education** (Cultural Narrative Method), **Zeng et al.**
- Narrative coherence via transitions → **Müller** (edge-level transition text).

**Next literature actions.**
1) Track keys in `docs/refs/references.bib` and cite them inline in design notes/tests.
2) Add 1–2 sentences in SPEC per feature explaining the design choice, with a parenthetical ref key.
3) Prioritize close reads: Müller (both papers), Howlett & Rayner (ordering arguments), Abad (task resumption, “switch→resume” metaphor for our walkthrough flow).
