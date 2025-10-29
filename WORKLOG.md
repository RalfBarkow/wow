# WORKLOG.md

# Worklog — Narrative Path Splitter

## 2025-10-28

* **Anchor to chat:** tied this project start to the **GtInputParser** effort (registry + `selectionExplanation`).
* Wrote initial SPEC/PLAN/RESEARCH/WORKLOG set.
* Defined mapping rules (H1 → file) and adapter responsibilities.
* Next: implement `GtSpecSetMarkdownParserAdapter`, register it, and add examples proving:
1. winner = our adapter on a `MASTER.md`,
2. `selectionExplanation` lists candidates and priorities,
3. end-to-end split creates/updates the four files idempotently.
