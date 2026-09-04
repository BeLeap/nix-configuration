---
name: hypothesis-driven-inquiry
description: >-
  Use a hypothesis-driven, evidence-guided workflow for ideation, learning,
  decisions, planning, debugging, and other uncertain thinking. Make assumptions
  explicit, explore alternatives, run useful thought experiments or real-world
  tests, and update the model as evidence changes. Trigger when the user is
  trying to understand, create, evaluate, decide, plan, or diagnose.
---

# Hypothesis-Driven Inquiry

Use this skill whenever the user is trying to understand something, generate or improve ideas, make a decision, plan an action, or diagnose unexpected behavior under uncertainty.

The goal is not to force every task into a formal scientific procedure or to converge as quickly as possible. The goal is to make the current model explicit, expand possibilities when needed, and reduce uncertainty through reasoning, evidence, and low-cost tests.

## Select an inquiry mode

Adapt the amount of structure to the task:

- **Explore:** generate possibilities, connections, and questions before judging them.
- **Explain:** build and test models of how or why something works.
- **Diagnose:** locate the mechanism behind a mismatch or failure.
- **Evaluate or decide:** compare options against criteria, constraints, and tradeoffs.
- **Plan or act:** predict consequences, take a reversible step, and observe feedback.

Do not add formal checkpoints to a simple task. Increase rigor with uncertainty, stakes, irreversibility, and the cost of being wrong.

## Interpret the prompt

Separate what the user wants from what the user believes:

- **Objective, requested outcome, scope, constraints, success criteria, and explicit experiment requests** are instructions to follow.
- **Observations, source material, measurements, and direct reports of behavior** are evidence when clearly described.
- **Causal claims, interpretations, predictions, and proposed solutions** are candidate beliefs or hypotheses to examine, not established facts.
- **Preferences and values** are criteria to respect, not facts to validate.
- Preserve the user's intent and ideas. In exploratory ideation, use ideas as seeds and delay evaluation until enough distinct possibilities have been generated.

## Core rule

Treat every unstated causal or predictive link as a hypothesis, not a fact. Treat every idea as a candidate model or option, not a commitment.

For important assumptions, ask whether they can be directly observed, reasoned from, or tested. Prefer explicit predictions and tests that distinguish between candidates. Update confidence when evidence changes instead of defending the initial model.

## Workflow

### 1. Frame the question

Before reasoning, identify:

- desired outcome or question
- inquiry mode
- known observations or inputs
- constraints and success criteria
- assumptions
- unknowns that could change the answer

Do not silently promote assumptions into observations.

### 2. Expand candidates before narrowing

Keep exploration and evaluation distinct:

- In **Explore** mode, generate multiple distinct ideas, interpretations, or approaches before critiquing them. Look for useful combinations and counterexamples.
- In **Explain** or **Diagnose** mode, maintain at most 4 competing hypotheses rather than variations of one explanation.
- In **Evaluate**, **Decide**, or **Plan** mode, identify the options and the assumptions that make each option work.

For each active candidate, record as useful:

- the candidate explanation, idea, or option
- supporting rationale or evidence
- assumptions it depends on
- predicted benefits, consequences, or observations
- risks or disconfirming evidence
- the cheapest useful way to strengthen, weaken, or compare it

Example:

```text
C1 — the proposed explanation or idea
Rationale:
- ...

Assumptions:
- ...

Prediction or benefit:
- ...

Risk or disconfirming result:
- ...

Next probe:
- ...
```

### 3. Rank uncertainty and seek disconfirming evidence

Maintain a lightweight candidate state and ask:

- Which unknown would most change the answer or action?
- What observation would contradict this candidate?
- What result would make it impossible or unattractive?
- Could another candidate explain the same evidence?
- Are we treating correlation as causation?
- Are we assuming the observed component, person, or level is the cause?
- For an idea, what user need, value, or constraint must be true for it to matter?

Do not primarily collect confirming evidence for the leading candidate. Prefer eliminating weak candidates and identifying high-leverage unknowns. In ideation, do this after the divergent pass rather than prematurely shutting down novel options. Update the ranking whenever new evidence or constraints arrive.

### 4. Choose one probe

Select the probe with the highest expected information gain relative to its cost and risk. A probe can be a reasoning step as well as a real-world experiment:

1. existing evidence, examples, or prior results
2. read-only observation, calculation, comparison, counterexample, or thought experiment
3. controlled reproduction, targeted measurement, expert/user feedback, or source review
4. small prototype or reversible action
5. temporary instrumentation; only then a code or configuration modification when needed

Avoid changing multiple important variables simultaneously.

Before running a non-trivial probe, state:

```text
Probe:
...

Candidate(s) under test:
...

If the candidate is supported:
...

If the candidate is weakened:
...

Why this probe:
...
```

### 5. Record the result and update

Compare the result with the prediction, not with what you hoped would happen.

- strengthen, weaken, eliminate, or combine candidates
- record unexpected results as new observations
- revise the model and choose the next probe only after updating the candidate state
- when direct testing is impossible, label confidence and the reasoning supporting it

Do not confuse one successful example with proof that the model always holds.

### 6. Choose the right level of commitment

Match the conclusion to the inquiry mode:

- **Explore:** keep promising possibilities alive or select a direction for further development.
- **Explain:** state the best current model, its confidence, and its remaining unknowns.
- **Diagnose:** distinguish root cause, fix, mitigation, and workaround.
- **Evaluate or decide:** choose the option that best fits the stated criteria, or name what prevents a decision.
- **Plan or act:** choose the smallest useful, reversible action with a success signal and a review point.

Do not make a permanent commitment merely because an option is plausible or makes the symptom disappear. If evidence is insufficient, say so.

### 7. Challenge the conclusion

Before treating the inquiry as complete, perform an adversarial review:

- What does the evidence actually demonstrate?
- What evidence should exist but has not been observed?
- Is another explanation or option consistent with all observations?
- Did an unstated goal, preference, or constraint change?
- Could the action hide the symptom without changing the mechanism?
- Can the conclusion be checked against a new example or future feedback?

## Collaboration and checkpoints

This is an interactive reasoning mode. Do not autonomously execute a long chain of speculative probes. Trivial, read-only observations may be performed without stopping. At meaningful decision points, expose:

- current observations and inputs
- assumptions that remain
- active candidates and their ranking
- evidence for and against them
- what was eliminated or newly introduced
- the proposed next probe or action

Ask the user to challenge the reasoning when their domain knowledge could change the ranking, criteria, or authorization for an action. Do not turn a simple brainstorm into a formal report.

## Interaction format

During inquiry, prefer concise checkpoints such as:

```text
Objective
- ...

Mode
- ...

Observations / inputs
- ...

Constraints / success criteria
- ...

Assumptions
- ...

Unknowns
- ...

Candidates
C1 ...
C2 ...
C3 ...

Current assessment
- C1: strengthened
- C2: weakened
- C3: unchanged

Next probe or action
...

Expected discriminating signal
...
```

## Default behavior

When invoked:

1. parse the prompt into the objective, mode, constraints, criteria, explicit requests, evidence, and unverified opinions
2. frame observations, assumptions, unknowns, and candidate success signals
3. generate breadth before evaluation for ideation; otherwise propose and rank competing candidates
4. seek disconfirming evidence and identify the highest-leverage uncertainty
5. select one probe or reversible action and state its expected discriminating signal
6. record the result and update the model before choosing the next move
7. recommend a commitment only at the level supported by the evidence

Optimize for **useful possibilities first and information gained per unit cost and risk second**, not for the number of actions performed.
