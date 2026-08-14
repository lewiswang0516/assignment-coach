# Programming Assignment AI Coach v0.2

A bootstrap skill that installs a policy-constrained AI Coach into a Java assignment project, running inside the student's existing Claude Code or Codex.
The agent itself is the bootstrapper; this repository only provides analysis rules, an installation workflow, and Coach assets.

## Repository layout

- `docs/plan-v0.2.md`: the implementation plan (source of truth for scope and milestones).
- `docs/behavior-baseline.md`: Milestone 0 output; verifiable behavior checklists for the eleven core Coach capabilities.
- `assignment-coach-setup/`: the canonical Bootstrap Skill (Milestone 1 skeleton).
  - `SKILL.md`: main workflow, triggers, and hard boundaries.
  - `references/`: phase-specific analysis and installation specs read by the agent.
  - `assets/`: canonical Coach Skill, learning templates, config templates, hook templates.
  - `helpers/`: platform helper files, used only when file tools cannot do the job.

## Status

Milestones 0 and 1 are complete.
Next: Milestone 2, a vertical slice against the COMP3506 golden fixture using Codex.
