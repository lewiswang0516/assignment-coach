# Interview Bank

The student may have to defend this assignment out loud: a viva, a demo, a lab check, or a code walkthrough with a marker.
This file is how you prepare them, from stage 0 onward and not only at the end.

## How to use this file

- Every question below is a template.
  Instantiate it against the student's real code, their real design decision, their real bug.
  A generic question teaches nothing; "why did you use a HashMap in `WordCounter.count`" does.
- Ask two or three questions at the end of every stage, drawn from the categories that fit what the student just did.
- Ask one question at a time.
  Wait for the answer.
  Do not stack three questions in one message.
- Never accept a vague answer.
  Probe with a follow-up until the answer is concrete or the student admits they do not know.
  "I do not know" is a useful, honest outcome; a hand-wave is not.
- Tell the student what you are doing: these are the kinds of questions an interviewer asks about this kind of submission.
- Scope every category to what the course actually teaches.
  The categories below are a menu, not a checklist.
  Before using a category, look for evidence in the assignment materials that the course covers that topic: the spec, the rubric, the marking criteria, provided lecture or style material.
  If a topic never appears there (for example, a course that does not teach time complexity), do not ask about it; a real interviewer for that course would not.
  When the materials leave it unclear, ask the student once what the course has covered, and keep their answer for the rest of the session.

## Judging answers

Judge on three things: is it concrete, is it about their own code, and does it survive one follow-up.

A strong answer:

- names the specific function, variable, structure, or line;
- states the reason in terms of the requirement or a property of the data, not in terms of style preference;
- knows the limits of its own claim, for example "this is O(n log n) because of the sort, and the rest is linear";
- survives a follow-up, and gets more precise rather than more vague under pressure.

A weak answer:

- repeats the question in different words;
- uses vocabulary without a referent: "it is more efficient", "it is cleaner", "it handles the edge cases";
- describes what the code does at the level a reader could see from the name, with nothing about why;
- changes story when pushed, or reaches for the coach to confirm.

When an answer is weak, do not correct it immediately.
Ask one narrower follow-up first.
Only after the follow-up, say what was missing.

## Part A: questions by stage

Use these at the end of the matching stage.

### Requirements questions

1. In one minute, what problem does this assignment ask you to solve?
2. What exactly are you being marked on for [task X]?
3. Which requirement is the easiest to misread, and how did you read it?
4. Where does the spec stop telling you what to do, and what did you decide there?
5. Which constraint applies to [task X] and which does not, and how do you know?
6. What did you have to ask your instructor about, and what did they say?

### Design questions

1. What is your approach in [component], in three sentences?
2. Why this data structure and not [obvious alternative]?
3. What alternative did you reject, and what was the trade-off?
4. Where in your design does the main requirement get satisfied?
5. What is the worst-case input for this design?
6. If you started again, what would you design differently?

### Implementation questions

1. Walk me through [function] line by line.
2. What is [variable] holding at the point [loop] starts, and at the point it ends?
3. Why is the loop bound written that way, and what happens on the last iteration?
4. What does [function] do if [input condition] happens?
5. Which line here took the longest to get right, and why?
6. Which part of this file are you least sure about?

### Testing questions

1. How do you know [function] is correct, beyond "the tests pass"?
2. Which of your tests would fail first if you broke [specific line]?
3. What case do your tests not cover?
4. Why did you pick these inputs and not others?
5. What does the provided test at [name] actually check, in your words?
6. How would you test the part that is hardest to test here?

### Debugging questions

1. What was the hardest bug in this assignment?
2. What was the symptom, and what was the cause?
3. How did you narrow it down?
4. How do you know the fix addresses the cause and not just the symptom?
5. What did you first think was wrong, and why were you wrong about it?
6. What would you do differently to catch that bug earlier next time?

## Part B: questions by type

These are the shapes real interviewers use.
Mix across categories in the mock interview.

### B1. Explain your code

1. What does [method] do, in your own words, without reading the code out?
2. Why is [data structure] the right container for [field], and what would break with [alternative]?
3. What is the responsibility of [class or module], and what is deliberately not its job?
4. Trace [specific input] through [function] and tell me the value of [variable] at each step.
5. What does this line do, and what would happen if I deleted it?
6. Why is [method] in this file rather than in [other file]?
7. What does the return value mean when [edge condition] holds?

Strong: names concrete values and control flow, and can trace an input without guessing.
Weak: paraphrases identifiers, or reads the code aloud instead of explaining it.
Follow-up on weak: "Give me a concrete input and tell me the exact output."

### B2. Justify decisions

1. Why this approach rather than [simpler or more obvious approach]?
2. What is the cost of your choice, and what did you gain for that cost?
3. Where did the requirement force this decision, and where was it your preference?
4. What assumption does this design make about the input, and is it safe?
5. You handled [case] by [behavior]; what other behavior was reasonable, and why did you rule it out?
6. If the marker said this is over-engineered, what would you say back?

Strong: names a real trade-off with both sides, and ties one side to a requirement or a property of the data.
Weak: "it is cleaner", "it is best practice", "that is how it is normally done".
Follow-up on weak: "Cleaner in what measurable way? What gets worse in exchange?"

### B3. Modify on the spot

1. If the requirement changed so that [X] must now also hold, what would you change and where?
2. Extend this to handle [new input type or new case]; talk me through the change, no typing.
3. If the input could no longer fit in memory, what part of your design breaks first?
4. If this had to work with duplicate keys, what changes?
5. If the ordering requirement was reversed, how many places would you touch?
6. Suppose [component] must become reusable by another module; what would you have to change in its interface?

Strong: names specific files and functions, and knows which parts are insulated from the change and which are not.
Weak: "I would just add an if", with no idea where; or a full redesign because they cannot locate the coupling.
Follow-up on weak: "Which file, which function, and what happens to the callers?"

### B4. Edge cases and testing

1. What input breaks this?
2. What happens on empty, null, a single element, and the maximum size?
3. How do you know it works, without pointing at the provided tests?
4. Which edge case did you find last, and how?
5. Which of your tests is the most valuable, and which would you delete?
6. What is untested here, and how risky is that?
7. What would a hostile input look like for this function?

Strong: gives specific inputs and the exact expected behavior, and admits the gaps.
Weak: "I handled all the edge cases".
Follow-up on weak: "Name three. What does each one return?"

### B5. Complexity and performance

Only use this category when the course covers complexity or performance: the spec or rubric mentions it, or the student confirms it was taught.
Skip it otherwise.

1. What is the time complexity of [function], and where does that come from?
2. What is the space cost, and what dominates it?
3. Where is the bottleneck if the input got a hundred times larger?
4. Which loop dominates, and what is the cost of the operation inside it?
5. Is the constant factor here relevant, and why or why not?
6. If you had to make this faster, what would you attack first, and what would you sacrifice?

Strong: derives the number from the structure of the code, and separates worst case from typical case.
Weak: quotes a complexity class with no derivation, or names the wrong dominating operation.
Follow-up on weak: "Point at the line that gives you that term."

### B6. Ownership probes

These are the questions that separate work the student did from work the student collected.
Ask at least two in every mock interview.
Some code may have been generated with the course's permission and disclosed, which is allowed; ask these questions about it anyway, because an interviewer will still expect the student to explain and defend every line they submitted.

1. Walk me through the hardest bug you hit and how you found it.
2. Which line took the longest to get right, and what made it hard?
3. What did you try first that did not work?
4. Which part of this did you write last, and why in that order?
5. What did you learn while doing this that you did not know before?
6. Where did you get stuck long enough to consider a different approach?
7. If I asked you to delete [file] and rewrite it now, how long would it take you?
8. What part of your own code do you dislike?

Strong: specific story with a timeline, a wrong turn, and a concrete resolution.
Weak: smooth, general, no wrong turns, no detail; or the story does not match what the code and its history look like.
Follow-up on weak: "What exactly did the error say? What did you change first?"
Do not accuse the student of anything.
Report what you observe: the answers were general, and an interviewer will notice.

## Mock interview protocol for stage 8

Run this once the student's work is close to submission.

### Before

1. Read the student's actual submitted code and their own notes.
   Questions come from that code, not from the spec and not from this file verbatim.
2. Build a set of eight to twelve questions covering at least: explain-your-code, justify-decisions, modify-on-the-spot, edge-cases-and-testing, and ownership.
   Add complexity-and-performance only when the course covers it (see B5).
3. Tell the student the interview is about to open, how long it will take, and that you will give no help while it is open.

### During

1. Ask one question at a time and wait.
2. Push back on weak answers with a narrower follow-up.
   Two follow-ups on a single question is enough; then move on and record it as shaky.
3. Give no hints, no corrections, no confirmations, and no encouragement about correctness while the interview is open.
   If the student asks for help, say the interview is open and offer to continue after it closes.
4. Record answers as the student wrote them, unedited.
5. Never write an answer for the student, and never record an answer you supplied as theirs.

### After

Give a readiness verdict per topic, not a single overall score.
Topics are the ones you asked about: requirements, design, each major component, testing, debugging, and complexity if it was in scope for this course.

For each topic, one of:

- solid: concrete answers that survived follow-ups;
- shaky: right idea, but vague or wobbling under one follow-up;
- gap: could not answer, or the answer was wrong.

For each shaky or gap topic, say exactly what to revisit and which stage to go back to.

Be honest.
Do not upgrade a verdict to be kind, do not average away a gap, and do not give a "ready" summary when a core component is a gap.
Say plainly if the student is not ready, and what the shortest path to ready looks like.

Finally, state what this exercise is and is not.
It tells the student whether they can currently defend the work.
It is not proof of academic integrity, and it must never be presented to anyone as evidence that the work is the student's own.
