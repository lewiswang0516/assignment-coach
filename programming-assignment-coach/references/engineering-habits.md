# Engineering habits

These are working habits, not course rules.
Nothing here comes from the assignment materials, so never present a habit as something the course requires; if the materials happen to require the same thing, say that the requirement is theirs, not yours.

Hold the student to these habits when you review their work.
When a piece of feedback comes from one of them, say which habit it is, so the student learns the habit and not just the one fix.

Every habit here is also something an assignment interviewer probes, and each entry says how.
The rules below are written as rules for the student to follow.

---

## Errors and honesty

### 1. Never swallow an error

An exception that is caught and ignored, or a failure hidden behind a returned default value, turns a bug you could see into a bug you cannot.
If the code cannot handle a failure, let it surface: throw, return the error, or report it.

Why it matters: "why is this catch block empty" is a classic interview question, and an empty one has no good answer.

### 2. Never claim code works without evidence

"It should work" is not a test result.
Run the oracle cases from stage 3 and report what actually happened, including the cases that failed.

Why it matters: a marker runs the code, so an unfounded claim in a report or an interview is found out immediately.

---

## Testing

### 3. A test must check meaningful behavior

A test asserts on something concrete: a value, a structure, a side effect, or the type of error raised.
A test that only shows the code runs without crashing proves almost nothing.

Why it matters: a marker reading the test sees the difference, and an interviewer will ask what a given test would catch.

---

## Debugging

### 4. Reproduce before you fix

Find the smallest concrete input that shows the bug, and keep it.
That input is how you prove the fix worked, and how you explain the bug afterwards.

Why it matters: "how did you find that bug" is asked in almost every walkthrough, and a fix with no reproduction has no story behind it.

---

## Working in steps

### 5. Work in small verified steps, and never build on a broken state

Get one thing working, confirm it runs, then move to the next thing.
When something breaks, go back to the last state that worked instead of stacking more changes on top of a failure.

Why it matters: a submission built on a broken state fails in ways nobody can locate, including you, in front of the interviewer.

### 6. Budget your attempts

After a few failed tries at the same fix, stop.
Write down what you observed, then step back and re-examine the hypothesis instead of trying a seventh variation.

Why it matters: thrashing burns the hours that reflection would have saved, and an interviewer can tell a reasoned fix from a lucky one.

---

## Fitting in

### 7. Follow the conventions the starter code and the spec establish

Match the naming, structure, and style already in the project, even when you prefer your own.
If you think a convention is wrong, say so in a comment or your report rather than quietly breaking it.

Why it matters: consistency is often marked, and "why does this file look different from the rest" is a question you would have to answer.

### 8. Check what already exists before writing a helper

Look through the starter code and the standard library for the thing you are about to write.
Reuse what is there instead of adding a second version of it.

Why it matters: duplicating a method that was provided is a common mark deduction, and an interviewer will ask why you did not use the one given to you.

### 9. Change the least that solves the problem

Fix the specific thing that is wrong, and leave the rest of the file alone.
A wide rewrite hides which change was the fix.

Why it matters: a small change is easier to verify, easier to undo, and easier to defend line by line.

---

## Simplicity

### 10. Prefer the simple solution you can fully explain

Between a plain version you understand completely and a clever version you half understand, take the plain one.
Reach for the clever one only when you can walk through it yourself.

Why it matters: in an interview a clever line you cannot explain is worth less than a plain line you own.

---

## Version control

### 11. Commit working states, with messages that say what changed and why

Commit when something works, not once at the end.
Run `git status` before you commit, so you know exactly which files are going in.

Why it matters: your history is the story you tell when asked how the work was built, and a single "final" commit tells none of it.

---

## What is deliberately not here

Professional engineering guidelines usually add a habit about searching for an existing open source solution before building something yourself.
That habit is left out on purpose.
On a marked assignment the point is that the student builds it, so pulling in a found solution is an integrity problem, not a saving.
If a student asks about it, say that, and point them at the course policy on external code.
