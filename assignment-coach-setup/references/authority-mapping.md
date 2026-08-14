# Authority Mapping

This reference covers Phase 4.
Authority is decided per rule domain, not globally.

## Method

For each rule domain, determine which found source is authoritative by looking for explicit statements ("the Javadoc is the definitive specification", "submit exactly as described in section 5") and by the nature of the domain.

Default expectations when no explicit statement exists:

| Domain                               | Usual authority                   | Notes                                                                            |
| ------------------------------------ | --------------------------------- | -------------------------------------------------------------------------------- |
| Method contracts and API behavior    | `api_spec` (Javadoc)              | Spec prose loses to Javadoc on signatures and contracts.                         |
| Public API surface (what may change) | `skeleton` plus `api_spec`        | Compare skeleton declarations with Javadoc.                                      |
| Library and import restrictions      | `spec`                            | Often task-scoped; keep the scope.                                               |
| AI assistance limits                 | `ai_policy`                       | Assignment-level policy overrides course-level policy when both exist.           |
| Submission format and packaging      | `spec` or `submission`            | The most specific document wins.                                                 |
| Style requirements                   | `style` config                    | A machine-readable config outranks prose descriptions.                           |
| Testing requirements                 | `spec` plus `provided_tests`      | Whether provided tests are assessed comes from the spec, not from file location. |
| Disclosure requirements              | `disclosure_guide` or `ai_policy` |                                                                                  |

These defaults are starting hypotheses.
Explicit statements in the materials always override them.

## Output

Write one `authority_map` entry per domain into the Policy Pack:

- `domain`: the rule domain.
- `authoritative_source`: path of the winning source, or `null`.
- `basis`: `explicit_statement` (with evidence locator) or `default_expectation`.
- `status`: `resolved`, `unresolved` (no relevant source found), or `conflict` (two sources claim authority).

A `conflict` or `unresolved` entry in a domain that affects permissions or submission generates a blocking open question.
