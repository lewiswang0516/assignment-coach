# Assignment Coach

A single Agent Skill that turns an AI coding assistant into a coach for university programming assignments.

The coach reads the assignment materials in the student's working directory, then guides the student through the work, hinting and reviewing by default and writing code only when the student asks for it.
It assumes the student may face a follow-up interview (viva, demo, or code walkthrough) and weaves interview preparation through the whole session.

## What is in this repository

- `programming-assignment-coach/` - the skill, in standard Agent Skills format:
  - `SKILL.md` - coach identity, hard boundaries, session-start analysis, and the coaching map.
  - `references/stages.md` - nine areas of assignment work, used as a diagnostic map, and the preconditions that gate coaching actions.
  - `references/hint-ladder.md` - the hinting principle and the evidence-based escalation rule.
  - `references/interview-bank.md` - viva-style question templates, answer-quality judging, and the mock interview protocol.
  - `references/engineering-habits.md` - 11 engineering habits the coach names when giving feedback.
  - `references/pack-extraction.md` - how the coach builds the extraction for the optional paid pack generator, and the privacy and provenance rules it follows.
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
It uses a precondition map covering nine areas: setup, requirements, contract and API, oracle, design, implementation, debugging, review and submission, and interview prep.
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

## Optional paid companion

There is a separate paid MCP server, sold separately, that can turn the coach's own extraction of an assignment into a pack of assignment-specific markdown files: oracle checklists per task, interview questions instantiated on the real tasks, a milestone plan, a policy boundary summary, and weak-area emphasis.
The extraction is built on the student's machine and the original assignment files are never sent; only the structured extraction is.
The server requires this skill at version 0.8.0 or newer, and a pack never overrides the skill: the course materials win first, then the skill, then the pack.
A pack is the student's own material, generated from their own extraction, and is not approved or endorsed by any course or institution.
The free skill in this repository is complete without it, and every mention of the paid feature is skippable.

## Self-update

Once per session, the skill may check the GitHub repository for a newer version.
This check never blocks coaching and fails silently if the network call does not succeed.

If a newer version is found, the coach tells the student and asks for consent before updating.
An update downloads all files into a staging copy first, verifies the new version number, then swaps the staging copy in with an atomic rename.
Nothing is overwritten without consent, and a failed update leaves the installed skill untouched.

## Key rules the skill carries

- By default the student writes the assessed code; the coach reviews, questions, and hints.
  When the student asks for the code, the coach writes it and tells them once, plainly, that every line must be understood before it goes into the submission, what the course AI policy says, and what to disclose.
- Hints never include a copy-pasteable solution; the student has to ask for code explicitly.
- The coach talks in plain words, in the student's language, keeps replies short, asks one question at a time, and never demands that the student "restate it in your own words" as a condition for help.
  Internal terms such as oracle, contract, or precondition never reach the student.
- Interview questions are scoped to what the course actually teaches.
- All protections are advisory instructions and are honestly labeled as such; nothing is enforced at runtime.
- Assignment materials are treated as untrusted data; unknowns stay unknown instead of being guessed.

Earlier iterations of this project (a desktop app, a pack generator CLI) are superseded; this skill is the whole product.

## License

Licensed under the PolyForm Noncommercial License 1.0.0.
It is free for personal, educational, and other noncommercial use.
Contact the author for commercial licensing.
