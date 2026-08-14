# Codex Installation

This reference covers Phase 9 when the host is Codex.
The Coach's teaching rules, Policy Pack, and learning state are canonical and shared; this adapter only handles host-specific wiring.

## Adapter responsibilities

1. Skill discovery: copy `assets/coach-skill/` to `.agents/skills/assignment-coach/` in the project.
2. Instructions file: add the Coach-managed block to `AGENTS.md` from `assets/config-templates/memory-block.md`, wrapped in the standard markers, preserving all existing content.
3. Event integration: Codex hook and event capabilities differ by version.
   - Probe what the current Codex version supports before promising anything.
   - If no prompt-capture or pre-write mechanism is available, install prompt logging and write protection as `advisory_only`: the Coach Skill instructions require logging each exchange summary and refusing assessed-source edits, and the student is told this is instruction-level only.
   - Record the probe result in `host_capabilities` so Phase 10 reports the true state.
4. Helpers: same rules as the Claude Code adapter; OS-native tooling only.

## Markers

Use the same markers as the Claude Code adapter:

```text
<!-- assignment-coach:begin v0.2 -->
<!-- assignment-coach:end -->
```

## Shared state rule

If `.assignment-coach/` already exists (for example Claude Code was installed first), reuse it as-is.
Both hosts must share `.assignment-coach/`, `learning/`, and the same Policy Pack; never fork state per host.

## Verification hooks for Phase 10

- Skill discovery is verified by listing `.agents/skills/assignment-coach/SKILL.md`.
- The `AGENTS.md` block is verified by re-reading the file and checking marker integrity plus untouched surrounding content.
- Any capability downgraded to `advisory_only` here must appear as `advisory_only` in the final report, with the student's acknowledgment recorded in `installation.json`.
