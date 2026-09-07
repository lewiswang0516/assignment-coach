# Pack Extraction

This file is for one job: building the structured extraction that the `generate_assignment_pack` tool takes, and handling what comes back.

The tool lives in an optional paid MCP server called `coach-pro`.
The free skill is complete without it.
If that server is not among the tools available to you, nothing in this file applies; read `Offering pack generation` in SKILL.md for the one thing you may say about it and move on.

What the feature does: you read the assignment materials on the student's machine, turn what you read into one JSON object, and call the tool.
The server validates the object, assembles markdown from it with no model call of its own, and returns a list of files.
You write those files into the project as an assignment-specific skill.

The original assignment files never leave the machine.
Only the object you build is sent, so the object decides what leaves the machine, and every rule below about paraphrasing and locators exists for that reason.

## Before you extract

Do not start an extraction cold.

1. The session-start analysis in SKILL.md is complete: you have read the materials yourself and summarized them back.
2. The student has confirmed or corrected that summary, and you are using their corrections.
3. The student has agreed to the call, knowing that a structured extraction is sent to the server and that their key allows 10 packs in total, for their lifetime, not per assignment.

If any of those is missing, close it first.
An extraction built on materials you have not read is a guess with a JSON schema around it.

The server requires `provenance.skill_version` to be `0.8.0` or newer and rejects anything older without consuming quota.
Send the version in this skill's frontmatter, and send it exactly.

## Privacy rules

These are hard rules on the object you build, not preferences.

- Send no absolute path.
  Every path and glob is relative to the project root.
  No leading `/` or `\`, no `C:\`, no `~`, no `..` segment, no `file:` or `https://` scheme.
- Quote nothing from the course materials in a locator field.
  A locator names a section or a heading, in your own words: `Section 2.2, collisions`, `Criterion 4`, `Javadoc on the provided interface`.
  Keep it under 120 characters, on one line, with no quotation marks of any kind.
- Send no student identifier anywhere.
  No email address, no student number, no `学号`, no bare run of digits that could be one.
  Paths and locators are both scanned for these and rejected.
- Paraphrase every free-text field: `summary`, `text`, `explanation`, `question`, `why_it_matters`.
  These are not scanned by the server, which means the discipline is entirely yours.
  Write one checkable claim in your own words.
  Never paste spec, rubric, or policy text into them, and never paste a block of the student's code.
- Send nothing about the student that the student did not tell you.
  Weak areas and goals are their words, collected in conversation, not your diagnosis of them.

If following these rules would lose information the pack needs, say so to the student and leave the field out.
A missing field makes the pack narrower; a leaked one breaks the promise the product is sold on.

## Provenance discipline

Every rule in the object carries an `origin`, and the pack prints it.
This is the honesty mechanism, so it is the part to be strict about.

- `official_explicit` - the materials say this in so many words.
  Requires at least one `evidence` entry naming the source type, and normally a locator.
- `official_derived` - the materials imply it and you can show the step.
  Also requires evidence.
  Use it when the build fails on a warning and you conclude the style rule costs marks, not when you think a rule is probably meant.
- `instructor_policy` - the student reports it from an announcement, a lecture, or a reply you cannot read.
  Say in `explanation` that it came from the student.
- `coach_guardrail` - your own coaching standard, such as the engineering habits.
  The pack prints these as "coaching standard, not a course rule" everywhere they appear.
  Never dress one of these as a course requirement.
- `unknown` - you found no origin.
  Set `status` to `unresolved` and raise an open question rather than picking a nicer origin.
- `conflict` - two materials say different things.
  Set `status` to `conflicting`, describe both readings, and raise an open question.

Never guess an origin to make a field validate.
An `official_explicit` you cannot locate is not an `official_explicit`.
Unknown stays unknown, here exactly as everywhere else in this skill.

## The object, field by field

Top level: `schema_version`, `assignment`, `tasks`, `ai_policy`, `artifacts`, `materials_coverage`, `open_questions` and `provenance` are required.
`global_constraints`, `course_topics`, `student_profile` and `pack_options` are optional.
Nothing else is allowed at any depth: an unmodelled field is rejected by name, which also stops raw spec text arriving inside a field nobody modelled.

`schema_version` is exactly `"1.0"`.

### `assignment`

- `id`, required: a slug, lowercase letters, digits, `.`, `-` or `_`, at most 64 characters.
  It becomes part of the pack directory name.
- `language`, required: the assignment's programming language as free text, taken from the materials.
- `title`, `course_code`, `build_command`, `test_command`: from the materials when stated.
  `course_code` prefixes the generated pack name.
- `due_at`: an ISO 8601 date-time, only if the materials state a deadline.
  Without it the milestone plan is skipped rather than guessed, which is the right outcome.
  Never convert "week 7" into a date.
- `timezone`: an IANA name such as `Australia/Brisbane`.
  It is recorded in the plan's assumptions; the arithmetic itself is in UTC.

### `tasks[]`

At least one task, and every per-task file in the pack is keyed to these.

- `id`, required: a slug, unique across tasks.
- `name`, required: the label the materials use for this task.
- `summary`, required: your paraphrase of what the task requires.
  Never the spec text.
- `marks`: the marks for the task, when the rubric states them.
  They split the implementation window in the milestone plan; a task without marks counts as one.
- `marking_points`, required, at least one: see below.
- `constraints`: task-scoped rules only.
  A restriction the spec puts on one task stays on that task, in the object as in the conversation.
  Anything that genuinely applies to the whole assignment goes in `global_constraints` instead.
- `deliverable_paths`: relative paths to the files that implement the task.
- `oracle_status`: `none`, `written` or `test`.
  It defaults to `none`, which makes the checklist lead with the missing oracle, so report it honestly.
  `test` means a test exists that actually asserts the behavior, not that a test file exists.
- `student_confidence`: `low`, `medium` or `high`, in the student's own judgment, asked for, never inferred.
- `depends_on`: ids of other real tasks, never the task itself.
  Take dependencies from the work, not from the order of sections in the handout.

### `marking_points[]`

Each one is a single checkable claim, and together they are the substance of the oracle checklists.

- `id`, required: a slug, unique within the task.
- `text`, required: one claim, paraphrased, in a form the student could check.
  "Removing an element by index shifts the later elements left and reduces the size by one" is a marking point; "handles removal correctly" is not.
- `source_type`, required: one of `spec`, `rubric`, `ai_policy`, `skeleton`, `api_spec`, `provided_tests`, `build`, `style`, `submission`, `disclosure_guide`.
- `source_locator`: the section or heading, quote-free.
- `status`, required: `resolved`, `unknown` or `conflicting`.
  Only `resolved` becomes a checklist item; the other two print as open questions in the pack.
  Do not upgrade a shaky point to `resolved` to get a longer checklist.

### `constraint` objects

The same shape is used by `tasks[].constraints`, `global_constraints` and `ai_policy.terms`.

- `id`, required: a slug, unique across every constraint in the whole object, including the policy terms.
  These ids are the pack's citation namespace.
- `domain`, required: `ai_assistance`, `library_restrictions`, `api_lock`, `file_modification`, `testing`, `submission`, `style` or `disclosure`.
  A policy term's domain must be `ai_assistance` or `disclosure`.
- `text`, required: the rule as the student needs to hear it, in your words.
- `origin`, required: as in `Provenance discipline` above.
- `status`, required: `resolved`, `unresolved` or `conflicting`.
  Anything other than `resolved` prints in the pack's conflicts and unknowns section.
- `evidence`: an array of `{ source_type, locator? }`.
  Required, with at least one entry, when `origin` is `official_explicit` or `official_derived`.
- `explanation`: one or two sentences on why the rule matters, aimed at the student.

### `ai_policy`

Required, because it drives the boundary file and supplies the first earned-generation condition.

- `found`, required: whether you found a policy at all.
  When false, say so, set the permission fields to `unknown`, and let the pack tell the student to ask the course.
  Do not fill this in from what courses usually say.
- `source_type`: `ai_policy`, `spec`, `rubric` or `disclosure_guide`.
- `generation_allowed`, required: `yes`, `no`, `conditional` or `unknown`.
  This is only the first of the five earned-generation conditions; the other four stay with you and are not delegated to a pack.
- `generated_tests_allowed`, required: the same four values.
- `disclosure_required`, required: `yes`, `no` or `unknown`.
- `disclosure_location`: where the disclosure goes, when the materials say.
- `terms`, required: the policy itemised as constraints, each with its own evidence.

### `artifacts[]`

Required, and the source of the pack's do-not-write list.

- `path_pattern`, required: a relative path or glob, unique across artifacts.
- `class`, required: `official_provided_source`, `assessed_implementation`, `assessed_tests`, `unassessed_tests`, `build_style_config`, `submission_artifact`, `ai_disclosure`, `student_reflection` or `coach_learning_evidence`.
- `agent_write`, required: whether you may write the file.
  This is the only permission a pack conveys.
  There is no read permission: you read the working directory before you ask the student anything, and no pack tells you not to read a file.
- `origin`, required: keeps the classification honest, same values as a constraint.
- `evidence`: optional, quote-free.

Classify provided tests as `assessed_tests` unless the materials show otherwise.
An `unassessed_tests` entry with no evidence produces a warning, and the uncertainty belongs in an open question rather than in a permissive classification.

### `materials_coverage[]`

Required.
One entry per source type you looked for, with `status` `found`, `unreadable`, `referenced_missing` or `version_conflict`.

Report this honestly, including the material you could not open and the rubric the spec refers to but does not ship.
Every entry that is not `found` produces a warning, and the pack prints the whole table so you can tell the student which parts of the pack rest on a material that was missing.
A coverage table that claims everything was found, when it was not, is the one lie that would make the whole pack look better than it is.

### `course_topics`

Optional, and it gates the topic-scoped interview questions.

- `covered`: topics evidenced in the materials.
- `source`: `materials`, `student_stated` or `unknown`.
  `student_stated` produces a warning, because the topic scope then rests on the student's word, which is correct and worth saying out loud.

The complexity and performance interview category is emitted only when a covered topic mentions complexity, performance, big-O or asymptotic analysis.
Otherwise the pack says the category was left out and why.
Do not add a topic to widen the question set.

### `student_profile`

Optional, and the only part of the object that comes from the student rather than from files.
Ask for it in conversation, briefly, and only if the student wants the emphasis and plan components:

- What do you feel weakest on for this assignment, and which task does it show up in?
  Record it as `weak_areas[]` with `topic`, optional `task_ids` naming real tasks, an optional `note` in their words, and an optional `severity` of `low`, `medium` or `high`.
- What do you want out of this assignment beyond the mark?
  Record short answers in `goals[]`.
- Realistically, how many hours a week do you have for this?
  `hours_per_week`.
- Any dates you know you cannot work?
  `unavailable_dates[]`, each `YYYY-MM-DD`.

Three or four questions, not an intake form.
Take the answers as given; do not soften a weak area the student named, and do not invent one they did not.
With neither `weak_areas` nor `goals`, the emphasis file is skipped and listed in `skipped`, which is a fine outcome.

### `open_questions[]`

Required, and this is where the unknowns go instead of into a guess.

Each entry has `id`, `question`, `why_it_matters`, and `blocking`, plus optional `answer` and `answered_at` when the student has already asked and been answered.
Write `question` as something the student can send to their instructor as it stands.
Write `why_it_matters` as the decision the answer changes.

Blocking or not:

- `blocking: true` when the answer changes what the pack itself would say.
  A contradiction between the spec and the rubric on a required behavior, a missing AI policy where the student wants generation, a task whose deliverable you cannot identify.
  A blocking entry returns an incomplete result and no pack, on purpose.
- `blocking: false` when the assignment can be worked on while the question is open, and the pack should carry the question rather than hide it.
  A late penalty nobody stated, an unstated growth factor, a tie-break the student can pick and document.

Do not mark a question blocking to be safe, and do not mark one non-blocking to get a pack out.
When something is blocking, tell the student what to ask, and offer to generate once they have an answer.

### `pack_options`

Optional.
`components` selects from `oracle_checklists`, `interview_bank`, `milestone_plan`, `policy_boundary` and `weak_area_emphasis`, and defaults to all five.
Anything left out is listed in `skipped`.
`locale` is `zh` or `en`; the pack files themselves are written in English because they are read by you and live in the project, and a `zh` request is honoured with a warning saying so.
You still reply to the student in the student's language.

### `provenance`

Required.
`produced_by` is exactly `programming-assignment-coach`, `skill_version` is this skill's version from the frontmatter, and `generated_at` is the current time as an ISO 8601 date-time.

## When validation fails

The server reports every problem at once, each with the exact field path and what is wrong with it, and a validation failure consumes no quota.

Fix your extraction and retry once.
Read each issue as a statement about your extraction, not about the schema.
If an issue says a locator is too long or looks quoted, rewrite it as a section name rather than trimming it to 120 characters.
If an issue says an official rule has no evidence, either find the evidence or change the origin to what you can actually support.

If the same call fails twice, stop, tell the student which fields you could not produce and why, and go on coaching without a pack.
Do not loop, and do not weaken a classification to get past the validator.

`skill_version_too_old` means the installed skill predates `0.8.0`; run the update in SKILL.md first.
`pack_quota_exhausted` means the key has generated its lifetime limit of 10 packs; say so plainly and do not retry.

## When it succeeds

The response carries `pack_name`, a `files` array of relative paths with content, `warnings`, `skipped`, and a `quota` block.

1. Write every file exactly as returned, under `.claude/skills/<pack_name>/`, keeping the relative paths inside it.
   On a host that uses the other layout, write under `.agents/skills/<pack_name>/` instead.
   Do not edit the content on the way in, do not reformat it, and do not merge it into an existing pack directory by hand.
2. Tell the student where the files went and what each one is for.
3. Report every entry in `warnings` in plain terms, and say what each one means for what the pack can claim.
   A missing material, a topic scope that rests on the student's word, and a test classification without evidence all change how much weight the pack carries.
4. Report every entry in `skipped` with its reason, so the student knows a component is absent rather than empty.
   A milestone plan skipped for a missing deadline is worth one sentence: the materials did not state a due date, so no plan was built.
5. Report the quota: how many packs this key has used and how many are left.
6. Say once that the pack is advisory, that it was assembled from your extraction of their materials, and that it can be wrong wherever your extraction was wrong.
   It is not instructor-approved, and the server stamps it `unverified` for exactly that reason.

Then read the pack and use it as described in SKILL.md.

## Keeping a pack honest afterwards

A pack is a snapshot of the materials at one moment.

When the materials change, the student gets an answer to an open question, or you find the extraction was wrong, regenerate the pack rather than editing the files.
Hand-editing breaks the one thing the pack has going for it, which is that it says exactly what the extraction said.
Tell the student that, and tell them a regeneration spends another pack from their key so it is worth batching a few corrections.

If a pack in the project is stale and cannot be regenerated, say which parts you no longer trust and coach from the materials instead.
Never let a stale pack outrank the course materials or this skill.
