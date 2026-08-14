# Verification, Update, and Uninstall

This reference covers Phase 10, the update flow, and the uninstall flow.
State meanings (`success`, `failed`, `advisory_only`, `unavailable`, `unverified`) follow `docs/behavior-baseline.md` in the project repository; the summary table below is self-contained for installation use.

## Phase 10 checks

Run every check; never skip silently.

1. Policy Pack: `.assignment-coach/policy-pack.json` parses and validates against `.assignment-coach/policy-pack.schema.json`, and its invariants hold (evidence present, no unresolved blocking questions if status is `complete`).
2. Skill discovery: the Coach Skill file exists at the host's discovery path.
3. State machine: `.assignment-coach/state.json` exists with the stage list compiled from the Policy Pack workflow, at the first stage.
4. Write protection: either a deny hook is registered and one blocked write was demonstrated on a scratch copy, or the capability is marked `advisory_only`/`unavailable` with the student's acknowledgment recorded.
5. Prompt logging: a test entry was appended to `.assignment-coach/logs/` and read back; hook-based capture verified if a hook was installed.
6. Response lint: lint rules compiled from the Policy Pack flag a deliberate sample violation.
7. Preflight: detects the Java project facts recorded in the Policy Pack and validates both JSON files.
8. Uninstall readiness: `installation.json` lists every created or modified file with hashes, and `backups/` contains a backup for every modified pre-existing file.

## Final report

Render one row per capability from the behavior baseline with its state.
List separately: verified items, unverified items, unavailable capabilities with reasons, failures with errors, and all skips with counts and reasons.
Never merge `advisory_only` into `success`, and never claim instructor approval of the pack.

## Update flow

Entered when `.assignment-coach/installation.json` already exists.

1. Read `installation.json` and compare recorded hashes against current files to detect student customizations.
2. Re-run Phases 2 through 8 only if assignment materials changed (hash drift in the source inventory); otherwise keep the existing Policy Pack.
3. Replace only content inside Coach markers and files the installation record owns; preserve student answers, learning entries, logs, and state history.
4. Re-run Phase 10 fully.
5. Never produce a second configuration set; one project has exactly one `.assignment-coach/`.

## Uninstall flow

1. Read `installation.json` for the full file list.
2. Restore every modified pre-existing file from `backups/`.
3. Remove Coach marker blocks from `AGENTS.md`, `CLAUDE.md`, and host settings, leaving surrounding content intact.
4. Remove Coach-created directories, except `learning/` and `.assignment-coach/logs/`, which the student may want to keep; ask before deleting those.
5. Report everything removed, everything restored, and anything that could not be restored with a reason.
