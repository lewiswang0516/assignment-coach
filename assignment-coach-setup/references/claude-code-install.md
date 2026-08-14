# Claude Code Installation

This reference covers Phase 9 when the host is Claude Code.
The Coach's teaching rules, Policy Pack, and learning state are canonical and shared; this adapter only handles host-specific wiring.

## Adapter responsibilities

1. Skill discovery: copy `assets/coach-skill/` to `.claude/skills/assignment-coach/` in the project.
2. Memory file: add the Coach-managed block to `CLAUDE.md` from `assets/config-templates/memory-block.md`, wrapped in the stable markers below, preserving all existing content.
3. Hooks: register hooks in `.claude/settings.json` from `assets/hook-templates/claude-code/`:
   - `UserPromptSubmit` hook appending to `.assignment-coach/logs/` for prompt logging.
   - `PreToolUse` hook on write/edit tools denying paths from the generated protected list, for assessed source write protection.
   - Merge into existing settings JSON; never replace the file wholesale; back up first.
4. Helpers: if a hook needs an executable helper, copy the platform file from `helpers/macos/` or `helpers/windows/`; helpers must run with OS-native tooling only (bash/zsh built-ins on macOS, cmd or stock PowerShell on Windows).

## Markers

All Coach-managed text blocks use these exact markers:

```text
<!-- assignment-coach:begin v0.2 -->
<!-- assignment-coach:end -->
```

Update mode replaces only the content between markers.
Uninstall removes the markers and everything between them.

## Shared state rule

If `.assignment-coach/` already exists (for example Codex was installed first), reuse it as-is.
Never create a second state, log, or Policy Pack location for this host.

## Verification hooks for Phase 10

- Skill discovery is verified by listing `.claude/skills/assignment-coach/SKILL.md`.
- Hook registration is verified by re-reading `.claude/settings.json` and checking the merged entries.
- Write protection is verified per behavior B6.2 in the behavior baseline: demonstrate one blocked write on a scratch copy, not on real assessed files.
