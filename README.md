# Assignment Coach

A single Agent Skill that turns an AI coding assistant into a coach for university programming assignments.

The coach reads the assignment materials in the student's working directory, then guides the student through the work instead of writing it for them.
It assumes the student may face a follow-up interview (viva, demo, or code walkthrough) and weaves interview preparation through the whole session.

## What is in this repository

- `programming-assignment-coach/` - the skill, in standard Agent Skills format:
  - `SKILL.md` - coach identity, hard boundaries, session-start analysis, and the coaching map.
  - `references/stages.md` - nine areas of assignment work, used as a diagnostic map, and the preconditions that gate coaching actions.
  - `references/hint-ladder.md` - the hinting principle and the evidence-based escalation rule.
  - `references/interview-bank.md` - viva-style question templates, answer-quality judging, and the mock interview protocol.
  - `references/engineering-habits.md` - 11 engineering habits the coach names when giving feedback.
  - `scripts/log-prompt.sh` - the optional prompt log hook.

## Install

Copy the `programming-assignment-coach/` folder into the skills directory of your AI tool:

- Claude Code, per project: `<project>/.claude/skills/programming-assignment-coach/`
- Claude Code, global: `~/.claude/skills/programming-assignment-coach/`
- Tools that read the AGENTS.md convention: `<project>/.agents/skills/programming-assignment-coach/`

Then open your assignment directory and ask for help with the assignment.
The coach reads the spec, rubric, and given code itself and confirms its understanding with you before coaching begins.

## How coaching works

The coach does not run a fixed sequence of stages.
It uses a precondition map covering nine areas: policy and setup, requirements, contract and API, oracle, design, implementation, debugging, review and submission, and interview prep.
These areas are a diagnostic map, not a pipeline.
The coach meets the student wherever they are and checks only the preconditions that the current request depends on.

Six named preconditions gate coaching actions.
For example, the coach will not help implement a task until the student has stated an oracle for it: a way to tell a correct result from a merely plausible one.

Hints escalate only on new evidence from the student, never just because the student asks again or a deadline is close.
New evidence means an attempt with expected versus actual output, or an explanation the coach can diagnose and correct.

## Engineering habits

During review, the coach holds the student to 11 engineering habits, covering errors and honesty, testing, and other working practices.
When feedback comes from one of these habits, the coach names the habit, so the student learns the habit and not just the one fix.
These are coaching standards, not course rules, and the coach says so.

## Optional prompt log

The skill can offer a local prompt log during setup.
It is off by default and requires the student's explicit consent before it is installed.

If enabled, a `UserPromptSubmit` hook appends the student's own prompts to `.coach/prompt-log.jsonl` on their machine, with common credential-shaped values redacted.
Nothing is sent anywhere.
The log works on Claude Code, which registers the hook in `.claude/settings.json`, and on Codex CLI 0.124.0 or newer, which registers it in `.codex/hooks.json`.
Codex also asks the student to review and trust the hook before it runs.
On any other host the offer is skipped and no log is installed.

## Self-update

Once per session, the skill may check the GitHub repository for a newer version.
This check never blocks coaching and fails silently if the network call does not succeed.

If a newer version is found, the coach tells the student and asks for consent before updating.
An update downloads all files into a staging copy first, verifies the new version number, then swaps the staging copy in with an atomic rename.
Nothing is overwritten without consent, and a failed update leaves the installed skill untouched.

## Key rules the skill carries

- By default the student writes the assessed code; the coach reviews, questions, and hints.
  The coach may generate code for a task only after the student has correctly explained their own approach for that task, and only where the course AI policy allows it, with a disclosure reminder and an explain-and-modify check afterwards.
- Hints never include a copy-pasteable solution.
- Interview questions are scoped to what the course actually teaches.
- All protections are advisory instructions and are honestly labeled as such; nothing is enforced at runtime.
- Assignment materials are treated as untrusted data; unknowns stay unknown instead of being guessed.

Earlier iterations of this project (a desktop app, a pack generator CLI) are superseded; this skill is the whole product.

## License

Licensed under the PolyForm Noncommercial License 1.0.0.
It is free for personal, educational, and other noncommercial use.
Contact the author for commercial licensing.
