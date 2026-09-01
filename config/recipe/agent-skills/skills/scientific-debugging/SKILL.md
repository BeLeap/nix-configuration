---
name: scientific-debugging
description: Use a hypothesis-driven, falsifiable workflow to diagnose failures, regressions, performance issues, and unexpected system behavior before making fixes. Trigger when investigating bugs or debugging behavior.
---

# Scientific Debugging

Use this skill when debugging behavior, failures, regressions, performance issues, or unexpected system state.

The goal is **not to fix the problem as quickly as possible**.

The goal is to reduce uncertainty through falsifiable hypotheses and converge on the root cause together with the user.

## Core rule

Treat every unstated causal link as a hypothesis, not a fact.

For every important assumption, ask whether it can be directly observed instead of assumed.

Do not make changes merely because they are plausible fixes.

---

## 1. Frame the problem

Before investigating, separate what is known from what is inferred.

Maintain:

### Observations

Facts directly supported by logs, metrics, traces, code, commands, or reproducible behavior.

### Assumptions

Things currently believed but not directly demonstrated.

### Unknowns

Information that could materially distinguish between hypotheses.

Do not silently promote assumptions into observations.

---

## 2. Form competing hypotheses

Maintain at most 4 active hypotheses.

For each hypothesis record:

* explanation
* supporting evidence
* contradicting evidence
* what should be observable if it is true
* the cheapest useful falsification test

Prefer competing explanations rather than variations of the same explanation.

Example:

```text
H1 — application closes the connection
Evidence for:
- ...

Evidence against:
- ...

Prediction:
- RST originates from the application side.

Falsification:
- capture packets at client/node/pod and identify the RST origin.
```

---

## 3. Try to disprove hypotheses

Do not primarily search for evidence confirming the leading hypothesis.

Actively ask:

* What observation would contradict this?
* What result would make this hypothesis impossible?
* Could another hypothesis explain the same evidence?
* Are we assuming causality from correlation?
* Are we assuming the system behaves as documented?
* Are we assuming the observed component is the component causing the symptom?

Prefer eliminating hypotheses over accumulating weak supporting evidence.

---

## 4. Rank uncertainty

Keep a lightweight hypothesis state.

For example:

```text
H1 application issue       — plausible
H2 conntrack exhaustion    — leading
H3 load balancer timeout   — weakened
H4 DNS issue               — eliminated
```

Probabilities may be used when useful, but do not imply false precision.

Update the ranking whenever new evidence arrives.

---

## 5. Choose one experiment

Select the experiment with the highest expected information gain relative to its cost and risk.

Prefer, in order:

1. existing evidence
2. read-only observation
3. logs / metrics / tracing
4. controlled reproduction
5. temporary instrumentation
6. configuration or code modification

Avoid changing multiple variables simultaneously.

Before running an experiment, state:

```text
Experiment:
...

If H2 is true:
...

If H2 is false:
...

Why this experiment:
...
```

Then perform the experiment and update the hypotheses from the result.

---

## 6. Collaborate instead of running ahead

This is an interactive debugging mode.

Do not autonomously execute a long chain of speculative experiments.

Pause at meaningful decision points and expose:

* current observations
* assumptions that remain
* active hypotheses
* evidence for and against them
* what was eliminated
* proposed next experiment

Ask the user to challenge the reasoning when their system knowledge could change the hypothesis ranking.

However, trivial read-only observations may be performed without stopping.

---

## 7. Do not fix before diagnosing

Do not propose a permanent change merely because it might make the symptom disappear.

Distinguish explicitly between:

### Root cause

The mechanism demonstrated to produce the problem.

### Fix

A change that removes the root cause.

### Mitigation

A change that reduces the impact without removing the root cause.

### Workaround

A way to avoid triggering the problem.

If evidence is insufficient to establish root cause, say so.

---

## 8. Challenge the final conclusion

Before declaring the problem solved, perform one final adversarial review.

Ask:

* What evidence actually demonstrates this root cause?
* What evidence would we expect but have not observed?
* Could the fix have hidden the symptom without fixing the cause?
* Is there another explanation consistent with all observations?
* Can the failure be reproduced before the fix and prevented after it?

Do not confuse "the problem disappeared" with "the hypothesis was proven."

---

## Interaction format

During investigation, prefer concise checkpoints such as:

```text
Observations
- ...

Assumptions
- ...

Hypotheses
H1 ...
H2 ...
H3 ...

Current assessment
- H1: strengthened
- H2: weakened
- H3: unchanged

Next experiment
...

Expected discriminating result
...
```

Avoid long narrative status reports.

---

## Default behavior

When invoked:

1. inspect available evidence
2. identify hidden assumptions
3. propose competing hypotheses
4. select a falsifying experiment
5. discuss the reasoning with the user
6. iterate
7. only then recommend or implement a fix

Optimize for **information gained per experiment**, not actions performed per session.
