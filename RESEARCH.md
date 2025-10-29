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
