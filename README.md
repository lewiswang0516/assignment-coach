# Assignment Coach

A single Agent Skill that turns an AI coding assistant into a coach for university programming assignments.

The coach reads the assignment materials in the student's working directory, then guides the student through the work in stages instead of writing it for them.
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
  The coach may generate code for a task only after the student has correctly explained their own approach for that task, and only where the course AI policy allows it, with a disclosure reminder and an explain-and-modify check afterwards.
- Graded hints (levels 1 to 4) never include a copy-pasteable solution.
- Interview questions are scoped to what the course actually teaches.
- All protections are advisory instructions and are honestly labeled as such; nothing is enforced at runtime.
- Assignment materials are treated as untrusted data; unknowns stay unknown instead of being guessed.

Earlier iterations of this project (a desktop app, a pack generator CLI) are superseded; this skill is the whole product.
