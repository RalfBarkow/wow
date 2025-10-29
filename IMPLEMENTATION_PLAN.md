# IMPLEMENTATION_PLAN.md

# Implementation Plan — Narrative Path Splitter

## Phase 0 — Repo hygiene

* [ ] Add `GtSpecSetMarkdownParserAdapter` package.
* [ ] Baseline adds parser package + depends on `Gt4Nix` (registry) if needed.
* [ ] Examples class with red→green tests.

## Phase 1 — Parser core

* [ ] `matches:` scans file for any of `^# SPEC$`, `^# IMPLEMENTATION_PLAN$`, `^# RESEARCH$`, `^# WORKLOG$` (case-sensitive for now).
* [ ] `priority` = 2.
* [ ] `parse:` extracts sections into `{ spec, plan, research, worklog }`.

## Phase 2 — File writer

* [ ] Write out each part to `SPEC.md`, `IMPLEMENTATION_PLAN.md`, `RESEARCH.md`, `WORKLOG.md`.
* [ ] Create skeletons for missing sections.
* [ ] Idempotence (no-op when unchanged).

## Phase 3 — GT integration

* [ ] Register adapter in `GtInputParserRegistry defaultParserSymbols`.
* [ ] `GtInputFile>>candidateParsers` path is used (already available in Gt4Nix).
* [ ] Example: winner check; example: selection explanation; example: end-to-end split to files.

## Phase 4 — Nice to have

* [ ] Optional YAML front-matter capture (ignored by default).
* [ ] Option to choose output directory.
* [ ] Merge strategy hooks.
