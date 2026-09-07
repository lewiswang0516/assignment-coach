# Assignment Coach

A single Agent Skill that turns an AI coding assistant into a coach for university programming assignments.

The coach reads the assignment materials in the student's working directory, then guides the student through the work in stages, hinting and reviewing by default and writing code only when the student asks for it.
It assumes the student may face a follow-up interview (viva, demo, or code walkthrough) and weaves interview preparation through every stage.

## What is in this repository

- `programming-assignment-coach/` - the skill, in standard Agent Skills format:
  - `SKILL.md` - coach identity, hard boundaries, session-start analysis, the nine-stage workflow.
  - `references/stages.md` - the nine stages, from policy and requirements through implementation, debugging, and interview preparation.
  - `references/hint-ladder.md` - four hint levels, from a conceptual nudge to a detailed walkthrough.
  - `references/interview-bank.md` - viva-style question templates, answer-quality judging, and the mock interview protocol.

## Install

Copy the `programming-assignment-coach/` folder into the skills directory of your AI tool:

- Claude Code, per project: `<project>/.claude/skills/programming-assignment-coach/`
- Claude Code, global: `~/.claude/skills/programming-assignment-coach/`
- Tools that read the AGENTS.md convention: `<project>/.agents/skills/programming-assignment-coach/`

Then open your assignment directory and ask for help with the assignment.
The coach reads the spec, rubric, and given code itself and confirms its understanding with you before coaching begins.

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
