Great—here’s an initial, copy-paste-ready quartet of docs that tie Müller’s “narrative path” formalism directly to your WOW project (position paper + live demo on topicmap-to-narrative generation across DMX/FedWiki/Elm).

---

### `SPEC.md`

````markdown
# SPEC — WOW 2025: From Topicmaps to Narrative Documents

**Project nickname:** WOW–Narrative Paths
**Date:** 2025-10-28
**Owners:** Ralf Barkow (rgb) et al.
**Goal:** Turn a topic map (DMX/AssocMap) into a readable narrative document by traversing *narrative paths* (per Müller) with personalization, variants, and coherent transitions; surface this as a FedWiki plugin + Elm UI backed by a DMX schema and a small “Path Selection API”.

## 1. Problem Statement
Knowledge bases excel at *structure* (triples, topic/association graphs) but struggle to produce *discourse*. We need a principled way to linearize graph knowledge into a coherent, audience-aware story.

## 2. Core Concepts
- **Topic node (T):** A DMX topic (page, definition, example, proof, etc.).
- **Association (A):**
  - `narrative(flowRef, transitionText?, contextAnnots?)`
  - `semantic(depKind, contextAnnots?)` (dependency/topological)
  - `variant(varKey, varValue, contextAnnots?)`
- **Narrative flow:** All `narrative` edges sharing the same `flowRef` (e.g., `intro`, `defn→theorem→proof`, `walkthrough`).
- **Narrative path:** A *simple* (no node repetition) sequence following one `flowRef`, optionally interleaving variant choices, producing a linear document with **transitionText** rendered at edge crossings.
- **Adaptation context Λ:** Ordered preferences/constraints (e.g., `level=beginner > language=de > domain=graph-theory`).

## 3. Scope
- **In scope:** DMX schema + seed data; Path Selection API; FedWiki plugin (inline) + Elm renderer; basic i18n; minimal authoring for flows & transitions; MCP/RAG hook (optional) for glosses.
- **Out of scope (WOW phase):** Full authoring UI, long-form NLG, heavy analytics, complex access control.

## 4. Deliverables
1. **WOW demo:** Select a topicmap “chapter”; get a personalized narrative document in FedWiki.
2. **Short paper/notes:** Method, schema, algorithm, falsification of “triples → text”.
3. **Repro env:** `flake.nix` + `.envrc`; fixtures; tests.

## 5. Data Model (DMX)
**Topic types (examples):** `Concept`, `Definition`, `Theorem`, `Proof`, `Example`, `Section`, `Chapter`.
**Assoc types:**
- `Narrative`: props `{ flowRef: String!, transitionText?: LocalizedString, context?: Map<String,String|Number>, weight?: Number }`
- `Semantic`: props `{ depKind: Enum(prereq|refines|introduces|requires), context?: Map }`
- `Variant`: props `{ varKey: String!, varValue: String!, context?: Map }`

**Context annotations:** key–value with ordered priority reflected from Λ.

## 6. API (Path Selection Service)
Base: `/api/narrative/v1`

- `POST /select`
  - **Body:**
    ```json
    {
      "start": "Topic:Chapter:LinearAlgebra",
      "flowRef": "intro-defn-proof",
      "maxLen": 50,
      "context": { "level": "beginner", "language": "en" }
    }
    ```
  - **Returns:**
    ```json
    {
      "path": [
        {"id":"T:Intro","title":"Why Eigenvectors?","type":"Section"},
        {"id":"T:Def:Eigenvector","type":"Definition"},
        {"id":"T:Thm:Spectral","type":"Theorem"},
        {"id":"T:Proof:Spectral","type":"Proof"}
      ],
      "edges": [
        {"from":"T:Intro","to":"T:Def:Eigenvector","transitionText":"As a first step, we define…"},
        {"from":"T:Def:Eigenvector","to":"T:Thm:Spectral","transitionText":"With this definition, we can state…"}
      ],
      "score": 0.82,
      "fallbackUsed": false
    }
    ```

- `GET /flows/:topicId` → available `flowRef`s + coverage stats.

## 7. Algorithm (selection + fallback)
1. **Candidate extraction:** From `start` (or globally), gather simple paths that follow `Narrative(flowRef=*)`.
2. **Scoring:** For each path P, compute `w(P)` as avg of node weights; node weight from context annotations vs Λ (ordered matching).
3. **Pick longest top-scoring P** (tie-break by coverage, recency, editorial priority).
4. **Fallback 1:** If no narrative candidate covers needed content, extend with `Semantic(depKind)` topological segments.
5. **Fallback 2:** If still sparse, apply *context-based sequencing* (heuristic order by type: Intro→Def→Thm→Proof→Ex).
6. **Variants:** Prefer edges/nodes whose `variant(varKey=…, varValue matches Λ)`; otherwise neutral default.

## 8. Rendering
- **FedWiki inline plugin** requests `/select` and renders:
  - Title + ToC from `path`.
  - For each hop: render `transitionText` then node content.
  - Flow switcher (chips): `intro`, `rigorous`, `walkthrough`.
  - Context switcher (dropdown): level, language.
- **Elm component**: state = `{flowRef, context, path, edges}`; ports for saving preferences and for DMX lookups.

## 9. Sequence (Graphviz)
```dot
digraph G {
  rankdir=LR;
  Client[label="FedWiki/Elm"];
  API[label="Path API"];
  DMX[label="DMX Topicmap"];
  Client -> API [label="POST /select (start,flowRef,Λ)"];
  API -> DMX [label="query narrative+semantic"];
  DMX -> API [label="nodes, edges, annots"];
  API -> API [label="score, choose, fallback"];
  API -> Client [label="path + transitions"];
}
````

## 10. Acceptance Criteria

* Given Λ=`{level: beginner, language: en}`, selecting flow `intro-defn-proof` produces a simple path, no repeats, with coherent transitions.
* Flow switch shows alternative `flowRef`s and recomputes within 200ms on cached graph.
* Fallback behavior demonstrable when narrative coverage is incomplete.
* Reproducible with `nix develop && npm run demo` (or `make demo`).

## 11. Non-Goals / Risks

* Non-goal: full NLG; we render preauthored transitions.
* Risks: sparse transitions; context conflicts; graph cycles (mitigated by simple-path constraint).

## 12. References

* C. Müller, *From Topics to Narrative Documents* (variant graphs; narrative flows; context-aware path selection).
* WOW 2025 submission guidelines (position + demo).

````

---

### `IMPLEMENTATION_PLAN.md`
```markdown
# Implementation Plan — WOW–Narrative Paths

## Phase 0 — Repo & DevShell (Day 0–1)
- Create mono-repo: `wow-narrative/` with packages:
  - `dmx-schema/` (seed JSON + scripts)
  - `path-api/` (TS/Node ESM; Fastify)
  - `fedwiki-plugin-narrative/` (client + inline plugin)
  - `elm-ui/` (Elm app)
  - `infra/` (flake.nix, .envrc, docker-compose for DMX)
- Add `flake.nix` devShell with Node 22/24, Elm 0.19.1, jq, graphviz, repomix-tools.
- CI: fmt, lint, test on push.

## Phase 1 — Data & Fixtures (Day 2–4)
- Define DMX types: Topic types + `Narrative` / `Semantic` / `Variant`.
- Import small exemplar map (10–20 nodes) with at least 2 `flowRef`s and 4 transitions.
- Script: `dmx-schema/seed.sh` to POST into DMX or produce static JSON fixture.

## Phase 2 — Path Selection API (Day 5–8)
- Implement `/select` (candidate enumeration, scoring, longest path, fallbacks).
- Implement `/flows/:topicId` (coverage stats).
- Unit tests: scoring, simple-path, variant preference, cycle handling.

## Phase 3 — FedWiki + Elm (Day 9–12)
- Inline plugin: request/response glue, render transitions, flow/context switchers.
- Elm state + ports; simple ToC; progressive rendering.
- Integration tests with fixture responses.

## Phase 4 — Polish & Demo (Day 13–14)
- i18n for transitions; example DE/EN.
- Caching; 200ms target on cached graph.
- Write WOW notes, screencast, reproducible script.

## Tasks (Backlog → Done)
- [ ] DMX schema & seed
- [ ] API: graph loader (from DMX or fixture)
- [ ] API: scoring & selection
- [ ] API: fallbacks
- [ ] API: tests
- [ ] Plugin: inline renderer
- [ ] Elm UI: flow/context switchers
- [ ] Elm UI: path view & transitions
- [ ] Demo: scripts & docs
- [ ] CI + flake + .envrc

## Repo Layout
````

wow-narrative/
flake.nix
.envrc
dmx-schema/
path-api/
fedwiki-plugin-narrative/
elm-ui/
infra/
docs/ (SPEC, PLAN, RESEARCH, WORKLOG)

```

## Definition of Done
- Specified acceptance criteria pass using fixtures and (optionally) a live DMX.
- Demo flows switchable; fallbacks observable; reproducible env.

## Risks & Mitigations
- **Sparse transitions:** add neutral stock transitions (“Next, we …”).
- **Context conflicts:** deterministic priority order in Λ; log decisions.
- **Graph cycles:** enforce simple paths; maximum length; visited set.

## Milestones
- M1 (Day 4): DMX seed + fixtures ready.
- M2 (Day 8): `/select` stable + tests.
- M3 (Day 12): Plugin + Elm integrated.
- M4 (Day 14): WOW demo & notes.
```

---

### `RESEARCH.md`

```markdown
# RESEARCH — WOW–Narrative Paths

## 1. Anchor Papers & Ideas
- Müller, *From Topics to Narrative Documents*: variant graphs; labeled narrative flows; context-based path selection; transitions at edges.
- Adaptive hypermedia & educational sequencing (Brusilovsky et al.): prerequisite/semantic edges as fallback.
- Rhetorical structure theory (RST): potential next step for richer transitions (post-WOW).
- Topic map engines (DMX / DeepaMehta 6): associative backends as an alternative to RDF triple stores.
- “From Triples to Text” (ongoing thread): critique—triples lack discourse relations and transitional intent; narrative edges supply that missing layer.

## 2. System Comparisons (falsification attempts)
- **Triples-only**: easy to query, hard to narrate. Missing: flow identity, variants, and edge-level transitions.
- **DMX topicmap w/ narrative edges**: encodes authorial intent (flowRef) and locality of transitions; supports straightforward selection & rendering.
- **RAG/MCP adjunct**: use Model Context Protocol endpoints (e.g., Wikidata MCP) for glosses/links; keep **narrative control** in graph metadata (authorial), not in generation.

## 3. Design Questions
- How granular should transitions be (edge vs. section)? → Start edge-level; allow section preambles.
- How to weight Λ? → Ordered constraints; per-node match yields [0,1]; average for path; tie-break by coverage/priority.
- How to mix flows? → WOW v1: single `flowRef` per path to ensure coherence; later allow stitched flows with explicit splice transitions.
- How to render variants? → Prefer variant matching Λ; otherwise default.

## 4. Experiments
- A/B: `intro-defn-proof` vs `walkthrough` for beginner vs advanced contexts.
- Latency: cached enumeration vs on-the-fly DMX fetch.
- Authoring load: number of transitions required for perceived coherence.

## 5. Implementation Notes
- Keep API deterministic for testability (seeded tie-break).
- Store transitions as LocalizedString; default to neutral stock if missing.
- Provide a fixture graph in `docs/fixtures/*.json` for reproducibility.

## 6. Next References to Explore
- Narrative generation in educational hypermedia.
- Graph linearization heuristics in documentation generators.
- MCP adapters: Wikidata MCP; MediaWiki connectors; feasibility for demo glosses.
```

---

### `WORKLOG.md`

```markdown
# WORKLOG — WOW–Narrative Paths

## 2025-10-28
- Created initial SPEC, IMPLEMENTATION_PLAN, RESEARCH, WORKLOG.
- Defined DMX schema outline and Path Selection API surface.
- Decided on single-flow narrative paths for WOW v1; fallbacks via semantic edges.
- Planned Elm/FedWiki integration with flow/context switchers.

### Decisions (ADRs)
- **ADR-001:** Narrative unit is a *simple path* over `Narrative(flowRef=…)`. No mixed flows in v1.
- **ADR-002:** Edge-level `transitionText` is rendered verbatim; no LLM generation in v1 (authorial control).
- **ADR-003:** Adaptation context Λ is ordered; average node weight scoring; tie-break by coverage, then editorial priority.
- **ADR-004:** Provide neutral stock transitions when missing to preserve coherence.

### TODO / Next
- [ ] Implement DMX seed + fixture export.
- [ ] Implement `/select` with scoring + longest-path + fallbacks.
- [ ] Wire FedWiki plugin + Elm with flow/context switchers.
- [ ] Add CI (fmt, lint, tests) and Nix devShell.
- [ ] Prepare WOW demo script and short paper outline.

### Known Issues / Risks
- Sparse transitions reduce narrative feel — mitigate with minimal stock transitions.
- Context clashes (e.g., beginner + terse) — log effective Λ and choice rationales.
```

---Great—here’s an initial, copy-paste-ready quartet of docs that tie Müller’s “narrative path” formalism directly to your WOW project (position paper + live demo on topicmap-to-narrative generation across DMX/FedWiki/Elm).

---

### `SPEC.md`

````markdown
# SPEC — WOW 2025: From Topicmaps to Narrative Documents

**Project nickname:** WOW–Narrative Paths  
**Date:** 2025-10-28  
**Owners:** Ralf Barkow (rgb) et al.  
**Goal:** Turn a topic map (DMX/AssocMap) into a readable narrative document by traversing *narrative paths* (per Müller) with personalization, variants, and coherent transitions; surface this as a FedWiki plugin + Elm UI backed by a DMX schema and a small “Path Selection API”.

## 1. Problem Statement
Knowledge bases excel at *structure* (triples, topic/association graphs) but struggle to produce *discourse*. We need a principled way to linearize graph knowledge into a coherent, audience-aware story.

## 2. Core Concepts
- **Topic node (T):** A DMX topic (page, definition, example, proof, etc.).
- **Association (A):**
  - `narrative(flowRef, transitionText?, contextAnnots?)`
  - `semantic(depKind, contextAnnots?)` (dependency/topological)
  - `variant(varKey, varValue, contextAnnots?)`
- **Narrative flow:** All `narrative` edges sharing the same `flowRef` (e.g., `intro`, `defn→theorem→proof`, `walkthrough`).
- **Narrative path:** A *simple* (no node repetition) sequence following one `flowRef`, optionally interleaving variant choices, producing a linear document with **transitionText** rendered at edge crossings.
- **Adaptation context Λ:** Ordered preferences/constraints (e.g., `level=beginner > language=de > domain=graph-theory`).

## 3. Scope
- **In scope:** DMX schema + seed data; Path Selection API; FedWiki plugin (inline) + Elm renderer; basic i18n; minimal authoring for flows & transitions; MCP/RAG hook (optional) for glosses.
- **Out of scope (WOW phase):** Full authoring UI, long-form NLG, heavy analytics, complex access control.

## 4. Deliverables
1. **WOW demo:** Select a topicmap “chapter”; get a personalized narrative document in FedWiki.
2. **Short paper/notes:** Method, schema, algorithm, falsification of “triples → text”.
3. **Repro env:** `flake.nix` + `.envrc`; fixtures; tests.

## 5. Data Model (DMX)
**Topic types (examples):** `Concept`, `Definition`, `Theorem`, `Proof`, `Example`, `Section`, `Chapter`.  
**Assoc types:**
- `Narrative`: props `{ flowRef: String!, transitionText?: LocalizedString, context?: Map<String,String|Number>, weight?: Number }`
- `Semantic`: props `{ depKind: Enum(prereq|refines|introduces|requires), context?: Map }`
- `Variant`: props `{ varKey: String!, varValue: String!, context?: Map }`

**Context annotations:** key–value with ordered priority reflected from Λ.

## 6. API (Path Selection Service)
Base: `/api/narrative/v1`

- `POST /select`
  - **Body:**  
    ```json
    {
      "start": "Topic:Chapter:LinearAlgebra",
      "flowRef": "intro-defn-proof",
      "maxLen": 50,
      "context": { "level": "beginner", "language": "en" }
    }
    ```
  - **Returns:**  
    ```json
    {
      "path": [
        {"id":"T:Intro","title":"Why Eigenvectors?","type":"Section"},
        {"id":"T:Def:Eigenvector","type":"Definition"},
        {"id":"T:Thm:Spectral","type":"Theorem"},
        {"id":"T:Proof:Spectral","type":"Proof"}
      ],
      "edges": [
        {"from":"T:Intro","to":"T:Def:Eigenvector","transitionText":"As a first step, we define…"},
        {"from":"T:Def:Eigenvector","to":"T:Thm:Spectral","transitionText":"With this definition, we can state…"}
      ],
      "score": 0.82,
      "fallbackUsed": false
    }
    ```

- `GET /flows/:topicId` → available `flowRef`s + coverage stats.

## 7. Algorithm (selection + fallback)
1. **Candidate extraction:** From `start` (or globally), gather simple paths that follow `Narrative(flowRef=*)`.
2. **Scoring:** For each path P, compute `w(P)` as avg of node weights; node weight from context annotations vs Λ (ordered matching).
3. **Pick longest top-scoring P** (tie-break by coverage, recency, editorial priority).
4. **Fallback 1:** If no narrative candidate covers needed content, extend with `Semantic(depKind)` topological segments.
5. **Fallback 2:** If still sparse, apply *context-based sequencing* (heuristic order by type: Intro→Def→Thm→Proof→Ex).
6. **Variants:** Prefer edges/nodes whose `variant(varKey=…, varValue matches Λ)`; otherwise neutral default.

## 8. Rendering
- **FedWiki inline plugin** requests `/select` and renders:
  - Title + ToC from `path`.
  - For each hop: render `transitionText` then node content.
  - Flow switcher (chips): `intro`, `rigorous`, `walkthrough`.
  - Context switcher (dropdown): level, language.
- **Elm component**: state = `{flowRef, context, path, edges}`; ports for saving preferences and for DMX lookups.

## 9. Sequence (Graphviz)
```dot
digraph G {
  rankdir=LR;
  Client[label="FedWiki/Elm"];
  API[label="Path API"];
  DMX[label="DMX Topicmap"];
  Client -> API [label="POST /select (start,flowRef,Λ)"];
  API -> DMX [label="query narrative+semantic"];
  DMX -> API [label="nodes, edges, annots"];
  API -> API [label="score, choose, fallback"];
  API -> Client [label="path + transitions"];
}
````

## 10. Acceptance Criteria

* Given Λ=`{level: beginner, language: en}`, selecting flow `intro-defn-proof` produces a simple path, no repeats, with coherent transitions.
* Flow switch shows alternative `flowRef`s and recomputes within 200ms on cached graph.
* Fallback behavior demonstrable when narrative coverage is incomplete.
* Reproducible with `nix develop && npm run demo` (or `make demo`).

## 11. Non-Goals / Risks

* Non-goal: full NLG; we render preauthored transitions.
* Risks: sparse transitions; context conflicts; graph cycles (mitigated by simple-path constraint).

## 12. References

* C. Müller, *From Topics to Narrative Documents* (variant graphs; narrative flows; context-aware path selection).
* WOW 2025 submission guidelines (position + demo).

````

---

### `IMPLEMENTATION_PLAN.md`
```markdown
# Implementation Plan — WOW–Narrative Paths

## Phase 0 — Repo & DevShell (Day 0–1)
- Create mono-repo: `wow-narrative/` with packages:
  - `dmx-schema/` (seed JSON + scripts)
  - `path-api/` (TS/Node ESM; Fastify)
  - `fedwiki-plugin-narrative/` (client + inline plugin)
  - `elm-ui/` (Elm app)
  - `infra/` (flake.nix, .envrc, docker-compose for DMX)
- Add `flake.nix` devShell with Node 22/24, Elm 0.19.1, jq, graphviz, repomix-tools.
- CI: fmt, lint, test on push.

## Phase 1 — Data & Fixtures (Day 2–4)
- Define DMX types: Topic types + `Narrative` / `Semantic` / `Variant`.
- Import small exemplar map (10–20 nodes) with at least 2 `flowRef`s and 4 transitions.
- Script: `dmx-schema/seed.sh` to POST into DMX or produce static JSON fixture.

## Phase 2 — Path Selection API (Day 5–8)
- Implement `/select` (candidate enumeration, scoring, longest path, fallbacks).
- Implement `/flows/:topicId` (coverage stats).
- Unit tests: scoring, simple-path, variant preference, cycle handling.

## Phase 3 — FedWiki + Elm (Day 9–12)
- Inline plugin: request/response glue, render transitions, flow/context switchers.
- Elm state + ports; simple ToC; progressive rendering.
- Integration tests with fixture responses.

## Phase 4 — Polish & Demo (Day 13–14)
- i18n for transitions; example DE/EN.
- Caching; 200ms target on cached graph.
- Write WOW notes, screencast, reproducible script.

## Tasks (Backlog → Done)
- [ ] DMX schema & seed
- [ ] API: graph loader (from DMX or fixture)
- [ ] API: scoring & selection
- [ ] API: fallbacks
- [ ] API: tests
- [ ] Plugin: inline renderer
- [ ] Elm UI: flow/context switchers
- [ ] Elm UI: path view & transitions
- [ ] Demo: scripts & docs
- [ ] CI + flake + .envrc

## Repo Layout
````

wow-narrative/
flake.nix
.envrc
dmx-schema/
path-api/
fedwiki-plugin-narrative/
elm-ui/
infra/
docs/ (SPEC, PLAN, RESEARCH, WORKLOG)

```

## Definition of Done
- Specified acceptance criteria pass using fixtures and (optionally) a live DMX.
- Demo flows switchable; fallbacks observable; reproducible env.

## Risks & Mitigations
- **Sparse transitions:** add neutral stock transitions (“Next, we …”).
- **Context conflicts:** deterministic priority order in Λ; log decisions.
- **Graph cycles:** enforce simple paths; maximum length; visited set.

## Milestones
- M1 (Day 4): DMX seed + fixtures ready.
- M2 (Day 8): `/select` stable + tests.
- M3 (Day 12): Plugin + Elm integrated.
- M4 (Day 14): WOW demo & notes.
```

---

### `RESEARCH.md`

```markdown
# RESEARCH — WOW–Narrative Paths

## 1. Anchor Papers & Ideas
- Müller, *From Topics to Narrative Documents*: variant graphs; labeled narrative flows; context-based path selection; transitions at edges.
- Adaptive hypermedia & educational sequencing (Brusilovsky et al.): prerequisite/semantic edges as fallback.
- Rhetorical structure theory (RST): potential next step for richer transitions (post-WOW).
- Topic map engines (DMX / DeepaMehta 6): associative backends as an alternative to RDF triple stores.
- “From Triples to Text” (ongoing thread): critique—triples lack discourse relations and transitional intent; narrative edges supply that missing layer.

## 2. System Comparisons (falsification attempts)
- **Triples-only**: easy to query, hard to narrate. Missing: flow identity, variants, and edge-level transitions.
- **DMX topicmap w/ narrative edges**: encodes authorial intent (flowRef) and locality of transitions; supports straightforward selection & rendering.
- **RAG/MCP adjunct**: use Model Context Protocol endpoints (e.g., Wikidata MCP) for glosses/links; keep **narrative control** in graph metadata (authorial), not in generation.

## 3. Design Questions
- How granular should transitions be (edge vs. section)? → Start edge-level; allow section preambles.
- How to weight Λ? → Ordered constraints; per-node match yields [0,1]; average for path; tie-break by coverage/priority.
- How to mix flows? → WOW v1: single `flowRef` per path to ensure coherence; later allow stitched flows with explicit splice transitions.
- How to render variants? → Prefer variant matching Λ; otherwise default.

## 4. Experiments
- A/B: `intro-defn-proof` vs `walkthrough` for beginner vs advanced contexts.
- Latency: cached enumeration vs on-the-fly DMX fetch.
- Authoring load: number of transitions required for perceived coherence.

## 5. Implementation Notes
- Keep API deterministic for testability (seeded tie-break).
- Store transitions as LocalizedString; default to neutral stock if missing.
- Provide a fixture graph in `docs/fixtures/*.json` for reproducibility.

## 6. Next References to Explore
- Narrative generation in educational hypermedia.
- Graph linearization heuristics in documentation generators.
- MCP adapters: Wikidata MCP; MediaWiki connectors; feasibility for demo glosses.
```

---

### `WORKLOG.md`

```markdown
# WORKLOG — WOW–Narrative Paths

## 2025-10-28
- Created initial SPEC, IMPLEMENTATION_PLAN, RESEARCH, WORKLOG.
- Defined DMX schema outline and Path Selection API surface.
- Decided on single-flow narrative paths for WOW v1; fallbacks via semantic edges.
- Planned Elm/FedWiki integration with flow/context switchers.

### Decisions (ADRs)
- **ADR-001:** Narrative unit is a *simple path* over `Narrative(flowRef=…)`. No mixed flows in v1.
- **ADR-002:** Edge-level `transitionText` is rendered verbatim; no LLM generation in v1 (authorial control).
- **ADR-003:** Adaptation context Λ is ordered; average node weight scoring; tie-break by coverage, then editorial priority.
- **ADR-004:** Provide neutral stock transitions when missing to preserve coherence.

### TODO / Next
- [ ] Implement DMX seed + fixture export.
- [ ] Implement `/select` with scoring + longest-path + fallbacks.
- [ ] Wire FedWiki plugin + Elm with flow/context switchers.
- [ ] Add CI (fmt, lint, tests) and Nix devShell.
- [ ] Prepare WOW demo script and short paper outline.

### Known Issues / Risks
- Sparse transitions reduce narrative feel — mitigate with minimal stock transitions.
- Context clashes (e.g., beginner + terse) — log effective Λ and choice rationales.
```

---

If you want, I can also drop in a starter `flake.nix` + `.envrc` and a tiny JSON fixture for the graph (topics + narrative/semantic edges) so you can run `nix develop && npm start` and see the path selection with mocked data.


If you want, I can also drop in a starter `flake.nix` + `.envrc` and a tiny JSON fixture for the graph (topics + narrative/semantic edges) so you can run `nix develop && npm start` and see the path selection with mocked data.
