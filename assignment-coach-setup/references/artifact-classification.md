# Artifact Classification

This reference covers Phase 5.
Every relevant file or path pattern gets exactly one class and explicit permissions.

## Classes

- `official_provided_source`: skeleton and support code supplied by the course.
- `assessed_implementation`: files the student must implement and that are marked.
- `assessed_tests`: provided or required tests that contribute to the mark or must not be modified.
- `unassessed_tests`: tests the student may freely write and change.
- `build_style_config`: build files and style configuration.
- `submission_artifact`: files or archives produced for submission.
- `ai_disclosure`: disclosure documents and exports.
- `student_reflection`: reflections and interview answers authored by the student.
- `coach_learning_evidence`: templates and records generated through Coach workflows.

## Permission record

Each artifact entry records four independent booleans: `student_read`, `student_write`, `agent_read`, `agent_write`.
Student permissions and agent permissions are never assumed equal.
Typical pattern: `assessed_implementation` is student-writable but never agent-writable; `assessed_tests` are readable by both and writable by neither.

## Classification evidence

Classification must cite evidence, the same way rules do.
The critical case: a test file is classified `unassessed_tests` only when the spec or another authoritative source explicitly permits modifying or ignoring it.
When evidence is absent, provided tests default to `assessed_tests`, and a non-blocking open question records the uncertainty.

Files created by the Coach itself (`.assignment-coach/`, `learning/`, `coach-tests/`) are classified `coach_learning_evidence` or `student_reflection` without external evidence, with origin `coach_guardrail`.

## Output

Write `artifacts` entries into the Policy Pack, each with `path_pattern`, `class`, the four permission booleans, `evidence`, and `origin`.
The assessed write-protection path list is generated from entries where `agent_write` is false and the class is `assessed_implementation` or `assessed_tests`.
