# Milestone 0: Coach Capability Behavior Baseline

This document converts the eleven core Coach capabilities from `docs/plan-v0.2.md` section 11 into verifiable behavior checklists.
Each capability declares its implementation channel, its observable behaviors, and the exact meaning of its `success`, `failed`, and `advisory_only` states.
The Phase 10 verification report must assign one of these states to every capability listed here.

## Implementation channels

Every behavior is implemented through exactly one of these channels:

- `skill_instruction`: enforced by instructions in the canonical Coach Skill that the host agent follows.
- `host_hook`: enforced by a hook registered in the host configuration (Claude Code hooks, Codex equivalents).
- `helper`: enforced by a bundled platform helper file, used only when file tools and hooks cannot do the job deterministically.
- `file_artifact`: enforced by the presence and structure of files the Bootstrap writes (state files, logs, templates).

Channel selection rule: prefer `skill_instruction` and `file_artifact`; use `host_hook` only for behaviors that must fire on host events; use `helper` only as a last resort.
A capability whose only available channel is `skill_instruction` can never be reported as hard-enforced; its best state is `advisory_only`.

## State definitions (shared)

- `success`: the behavior was installed, and a concrete verification check confirmed it works in this project on this host.
- `failed`: installation or verification was attempted and produced an error; the final report must show the error.
- `advisory_only`: the behavior is active as instructions or conventions, but no host-level mechanism prevents violation; the student was told this explicitly.
- `unavailable`: the host or platform lacks the required capability; the behavior was skipped with a recorded reason.

Silent downgrades are forbidden.
If a capability planned as `host_hook` ends up as `skill_instruction`, its state must be `advisory_only`, never `success`.

## 1. Stage state machine

Purpose: force the learning workflow through ordered stages (policy, requirements, contract, test-oracle, design, implementation, debug, review, interview) with explicit gates.

Channels: `file_artifact` (`.assignment-coach/state.json`) plus `skill_instruction` (Coach reads and honors state).

Verifiable behaviors:

- B1.1 `state.json` exists after install, with the stage list compiled from the Policy Pack workflow section.
- B1.2 Current stage, completed stages, and gate results are persisted across sessions and across hosts.
- B1.3 The Coach refuses to provide stage-N assistance while an earlier gate is unmet, and says which gate is unmet.
- B1.4 Stage transitions append a timestamped entry to the state history; transitions are never rewritten retroactively.

States: `success` requires B1.1 and B1.2 verified by file inspection; B1.3 and B1.4 are instruction-driven, so the machine as a whole is at best `advisory_only` on gate enforcement, and the report must say so.

## 2. Test-oracle gate

Purpose: require the student to state expected behavior (a test or written oracle) before the Coach discusses implementation.

Channels: `skill_instruction` plus `file_artifact` (`learning/03-test-oracle.md`).

Verifiable behaviors:

- B2.1 The oracle template exists and defines what counts as a committed oracle.
- B2.2 The Coach checks for a recorded oracle covering the current task before giving implementation help.
- B2.3 If provided tests are classified as assessed tests in the Policy Pack, the Coach never asks the student to modify them to satisfy the gate.

States: `success` when B2.1 verified and B2.2 exercised once during verification; the gate itself is `advisory_only` because no hook can inspect conversational intent.

## 3. Hint ladder

Purpose: escalate help gradually (concept, strategy, pseudocode-level, targeted) instead of emitting solutions.

Channels: `skill_instruction` plus `file_artifact` (hint level recorded in `state.json`).

Verifiable behaviors:

- B3.1 The ladder levels and the escalation condition for each level are defined in the Coach Skill and read from the Policy Pack rules where the assignment restricts help further.
- B3.2 Each hint given records its level and target in the log.
- B3.3 The Coach never emits complete assessed-implementation code at any ladder level.

States: B3.1 verifiable by file inspection (`success`); B3.2 and B3.3 are `advisory_only` unless a response linter hook is active, in which case B3.3 can be `success`.

## 4. Debug protocol

Purpose: structure debugging as observe, hypothesize, isolate, verify, instead of pasting fixes.

Channels: `skill_instruction` plus `file_artifact` (`learning/06-debug.md`).

Verifiable behaviors:

- B4.1 The debug template exists and captures symptom, hypothesis, experiment, and result fields.
- B4.2 The Coach requires a filled symptom and hypothesis before proposing an experiment.
- B4.3 Debug sessions reference the failing test or oracle entry they relate to.

States: `success` for B4.1 by file inspection; B4.2 and B4.3 are `advisory_only`.

## 5. Prompt logging

Purpose: record real AI interactions so the disclosure export is based on evidence, not memory.

Channels: `host_hook` preferred (Claude Code `UserPromptSubmit` or Codex equivalent), `file_artifact` (`.assignment-coach/logs/`).

Verifiable behaviors:

- B5.1 The log directory exists and is writable; a test entry can be appended and read back.
- B5.2 When a hook is available, every user prompt in the project produces a log entry with timestamp and host identifier.
- B5.3 Log entries are append-only by convention; the Coach never edits or backfills entries.
- B5.4 If no hook is available on this host, logging is downgraded and the student is told logs will be Coach-written summaries, not verbatim capture.

States: `success` requires B5.1 plus a live hook verified by B5.2; hook absent means `advisory_only` with B5.4 confirmed; write failure means `failed`.

## 6. Assessed source write protection

Purpose: prevent the agent from editing files classified as assessed implementation or assessed tests.

Channels: `host_hook` (pre-write deny hook) with optional `helper`; fallback `skill_instruction`.

Verifiable behaviors:

- B6.1 The protected path list is generated from Policy Pack artifact classifications, not hardcoded.
- B6.2 With the hook active, an attempted agent write to a protected path is blocked, and the block was demonstrated once during verification on a scratch copy.
- B6.3 Student edits through their editor are never blocked; protection applies to agent tool calls only.
- B6.4 If the host cannot register a deny hook, the capability is reported as `advisory_only` and the student must acknowledge it.

States: `success` only with B6.2 demonstrated; otherwise `advisory_only` or `unavailable`; never silently assumed.

## 7. Response linter

Purpose: check Coach output against the Policy Pack before delivery, catching solution leaks and scope violations.

Channels: `host_hook` where the host supports post-response hooks; otherwise `skill_instruction` self-check.

Verifiable behaviors:

- B7.1 The lint rules (no full assessed implementations, no assessed-test edits, library restrictions respected per task scope) are compiled from the Policy Pack.
- B7.2 A deliberate violation sample is flagged during verification.
- B7.3 Lint findings are logged, not silently discarded.

States: `success` with hook plus B7.2 passing; self-check-only mode is `advisory_only`.

## 8. AI-off interview

Purpose: provide a stage where the student answers comprehension questions without AI assistance, producing evidence of understanding.

Channels: `skill_instruction` plus `file_artifact` (`learning/08-interview.md`).

Verifiable behaviors:

- B8.1 The interview template exists with question slots derived from the assignment's rubric domains.
- B8.2 The Coach generates questions from the student's own submitted work, not generic trivia.
- B8.3 The Coach records that it did not answer during the interview window, and marks the interview entry as student-authored.
- B8.4 The Coach never claims the interview proves academic integrity; it is framed as self-assessment evidence.

States: B8.1 is `success` by inspection; the no-assistance guarantee is `advisory_only` and must be labeled as such.

## 9. Disclosure export

Purpose: assemble an AI-use disclosure document from real logs and learning artifacts.

Channels: `skill_instruction` plus `file_artifact`.

Verifiable behaviors:

- B9.1 The export is generated only from `.assignment-coach/logs/` and `learning/` contents; entries without a log source are excluded and the exclusion count is reported.
- B9.2 The export format follows the course's disclosure guide when one was found, otherwise a generic template, with the choice recorded.
- B9.3 If logging was `advisory_only`, the export carries a visible statement that capture was not verbatim.
- B9.4 The export never asserts instructor approval of the Policy Pack.

States: `success` when a sample export is generated during verification and B9.1 accounting is present; `failed` if generation errors.

## 10. Preflight

Purpose: before a work session, confirm the project still matches the Policy Pack (Java project detected, protected paths present, state file valid).

Channels: `skill_instruction` plus `file_artifact`; optional `host_hook` on session start.

Verifiable behaviors:

- B10.1 Preflight detects the Java build system and source roots recorded in the Policy Pack and reports drift.
- B10.2 Preflight validates `policy-pack.json` and `state.json` against their schemas.
- B10.3 Preflight failures block Coach assistance until acknowledged; they are never auto-suppressed.
- B10.4 Preflight ran successfully once during installation verification.

States: `success` requires B10.4; missing session-start hook downgrades automatic triggering to `advisory_only` while manual preflight remains `success`.

## 11. Safe install, update, and uninstall

Purpose: make every filesystem change reversible and idempotent.

Channels: `skill_instruction` plus `file_artifact` (`installation.json`, `backups/`, markers).

Verifiable behaviors:

- B11.1 `installation.json` lists every file created or modified, with content hashes and backup locations.
- B11.2 All Coach-managed blocks in `AGENTS.md`, `CLAUDE.md`, and host configuration use stable begin/end markers; content outside markers is byte-identical before and after install.
- B11.3 Re-running install detects the existing installation and enters update mode; no duplicate configuration is created.
- B11.4 Uninstall restores backed-up files, removes Coach-managed blocks and directories, and reports anything it could not restore with a reason.
- B11.5 Any skipped or partially completed step is reported with count and reason in the final summary.

States: `success` requires B11.1 through B11.3 verified during installation; uninstall correctness is verified in Milestone 6 regression, and until then it is reported as `unverified`.

## Channel summary

| Capability                    | Primary channel   | Hard-enforceable     | Best state without hooks |
| ----------------------------- | ----------------- | -------------------- | ------------------------ |
| Stage state machine           | file_artifact     | Partially            | advisory_only (gates)    |
| Test-oracle gate              | skill_instruction | No                   | advisory_only            |
| Hint ladder                   | skill_instruction | Partially via linter | advisory_only            |
| Debug protocol                | skill_instruction | No                   | advisory_only            |
| Prompt logging                | host_hook         | Yes                  | advisory_only            |
| Write protection              | host_hook         | Yes                  | advisory_only            |
| Response linter               | host_hook         | Yes                  | advisory_only            |
| AI-off interview              | skill_instruction | No                   | advisory_only            |
| Disclosure export             | file_artifact     | Yes (provenance)     | success                  |
| Preflight                     | file_artifact     | Yes (manual)         | success                  |
| Safe install/update/uninstall | file_artifact     | Yes                  | success                  |

The explanations for this table live in the per-capability sections above.
The final Phase 10 report must render one row per capability with its actual state, and must never merge `advisory_only` into `success`.
