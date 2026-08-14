# Policy Pack Schema

schema_version: 0.2

This reference covers Phase 8.
The machine-readable JSON Schema is bundled at `assets/config-templates/policy-pack.schema.json`; copy it into `.assignment-coach/policy-pack.schema.json` during installation so preflight can validate against it.
This document explains the intent behind each section.

## Top level

```json
{
  "schema_version": "0.2",
  "assignment": {
    "id": "generated-id",
    "language": "java",
    "pack_origin": "student_generated",
    "approval_status": "unverified"
  },
  "sources": [],
  "authority_map": [],
  "artifacts": [],
  "rules": [],
  "workflow": [],
  "open_questions": [],
  "host_capabilities": [],
  "installation": {}
}
```

- `assignment.id`: generated slug, stable across updates, for example `comp3506-a1-2026s2`.
- `assignment.pack_origin`: always `student_generated` in v0.2.
- `assignment.approval_status`: always `unverified` in v0.2; `instructor_signed` is reserved for a future instructor flow and must never be self-assigned.

## Sections

- `sources`: entries from Phase 2, shape defined in `analysis-workflow.md`.
- `authority_map`: entries from Phase 4, shape defined in `authority-mapping.md`.
- `artifacts`: entries from Phase 5, shape defined in `artifact-classification.md`.
- `rules`: entries from Phase 6, shape defined in `analysis-workflow.md`; each rule requires `id`, `domain`, `value` or unresolved `status`, `scope`, `origin`, `evidence`, `enforcement`, and `explanation`.
- `workflow`: the ordered learning stages with per-stage gates; the default stage list mirrors the nine learning templates, adjusted for what the assignment assesses (for example, algorithm-analysis assignments extend the design stage).
- `open_questions`: entries from Phase 7 including answers.
- `host_capabilities`: one entry per host discovered on this machine, recording which enforcement channels (hooks, helpers) are available, so Phase 10 can distinguish `advisory_only` from `success`.
- `installation`: summary written during Phase 9 with `installed_at`, `bootstrap_skill_version`, `hosts_installed`, and `status` (`complete` or `incomplete`).

## Invariants

- Every `rules[]` entry with origin `official_explicit` or `official_derived` has at least one evidence locator.
- No rule with origin `coach_guardrail` uses language implying course authority in its `explanation`.
- `installation.status` is `incomplete` while any `open_questions[]` entry has `blocking: true` and no `answer`.
- Unknown extra fields are rejected by the schema to keep packs comparable across fixtures.
