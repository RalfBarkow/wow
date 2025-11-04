# Implementation Plan — WOW–Narrative Paths

## Phase 0 — Repo & DevShell (Day 0–1)
- Monorepo `wow-narrative/`:
  - `dmx-schema/` (types + seed)
  - `path-api/` (Fastify, ESM, TS)
  - `fedwiki-plugin-narrative/`
  - `elm-ui/`
  - `infra/` (flake.nix, .envrc, docker-compose for DMX)
- DevShell: Node 22/24, Elm 0.19.1, jq, graphviz, repomix-tools.

## Phase 1 — Data & Fixtures (Day 2–4)
- DMX types: `Narrative`, `Semantic`, `Variant`.
- Seed fixture: 12–20 nodes, ≥2 flows, 4+ transitions, variant group for a proof (`difficulty=medium|high`). :contentReference[oaicite:16]{index=16}

## Phase 2 — Adaptation Engine (Day 5–8)
- **Substitution (variants):** implement “hole” filling by ranking variant sets vs. Λ (variant sorter). :contentReference[oaicite:17]{index=17}
- **Reordering (structure):** implement narrative ordering; fallback semantic ordering; final fallback context ordering. :contentReference[oaicite:18]{index=18}
- **Traversal:** longest simple narrative path + match scoring (avg node weights); semantic fallback; append with de-dup. :contentReference[oaicite:19]{index=19}
- Endpoints: `POST /select`, `GET /flows/:topicId`.

## Phase 3 — FedWiki + Elm (Day 9–12)
- Inline plugin: query API; render transitions; flow/context switchers.
- Elm state + ports; ToC; progressive render.

## Phase 4 — Polish & Demo (Day 13–14)
- i18n transitions; caching; WOW notes & screencast.

## Tests
- Unit: variant ranking, simple-path constraint, scoring/tie-breaks, dedup append.
- Integration: two flows; semantic fallback when narrative gaps exist; context flip changes selected variant.

## DoD
- Demo: switch flows and contexts live; transitions render; fixtures reproducible with `nix develop && npm run demo`.

## Risks/Mitigations
- Sparse transitions → seed stock transitions (“Next, we …”). :contentReference[oaicite:20]{index=20}
- Conflicting contexts → deterministic priority in Λ; log decision trace.
- Graph cycles → visited set; max path length.
