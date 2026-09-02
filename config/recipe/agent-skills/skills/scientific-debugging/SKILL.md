---
name: scientific-debugging
description: Use a hypothesis-driven, falsifiable workflow to diagnose failures, regressions, performance issues, and unexpected system behavior before making fixes. Trigger when investigating bugs or debugging behavior.
---

# Scientific Debugging

Use this skill when debugging behavior, failures, regressions, performance issues, or unexpected system state.

The goal is **not to fix the problem as quickly as possible**.

The goal is to reduce uncertainty through falsifiable hypotheses and converge on the root cause together with the user.

## Interpret the debugging prompt

During scientific debugging, separate what the user wants from what the user believes:

- **Objective, requested outcome, scope, constraints, and explicit experiment requests** are instructions to follow.
- **Suspected causes, interpretations of evidence, and proposed fixes** are opinions or hypotheses to test, not established facts or implementation instructions.
- Treat direct reports of observed behavior as observations when clearly described; treat any causal explanation attached to them as a hypothesis.
- Convert each opinion into a named hypothesis and test it against observations before changing code or configuration.
- Preserve the requested objective and scope, but do not treat a proposed fix as a permanent implementation instruction until evidence supports it. Label a change as an experiment, mitigation, workaround, or fix according to the evidence.

## Core rule

Treat every unstated causal link as a hypothesis, not a fact.

For every important assumption, ask whether it can be directly observed instead of assumed.

Do not make changes merely because they are plausible fixes.

## Workflow

### 1. Frame the problem

Before investigating, separate what is known from what is inferred.

Maintain:

#### Observations

Facts directly supported by logs, metrics, traces, code, commands, or reported behavior.

#### Assumptions

Things currently believed but not directly demonstrated.

#### Unknowns

Information that could materially distinguish between hypotheses.

Do not silently promote assumptions into observations.

### 2. Form competing hypotheses

Maintain at most 4 active hypotheses.

For each hypothesis record:

- explanation
- supporting evidence
- contradicting evidence
- what should be observable if it is true
- the cheapest useful falsification test

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

### 3. Rank uncertainty and seek disconfirming evidence

Keep a lightweight hypothesis state.

For example:

```text
H1 application issue       — plausible
H2 conntrack exhaustion    — leading
H3 load balancer timeout   — weakened
H4 DNS issue               — eliminated
```

Do not primarily search for evidence confirming the leading hypothesis. Actively ask:

- What observation would contradict this?
- What result would make this hypothesis impossible?
- Could another hypothesis explain the same evidence?
- Are we assuming causality from correlation?
- Are we assuming the system behaves as documented?
- Are we assuming the observed component is the component causing the symptom?

Prefer eliminating hypotheses over accumulating weak supporting evidence. Update the ranking whenever new evidence arrives.

### 4. Choose one experiment

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

Hypothesis under test: H2

If H2 is true:
...

If H2 is false:
...

Why this experiment:
...
```

### 5. Collaborate and update

This is an interactive debugging mode.

Do not autonomously execute a long chain of speculative experiments. At meaningful decision points, especially before a costly or risky experiment, expose:

- current observations
- assumptions that remain
- active hypotheses
- evidence for and against them
- what was eliminated
- proposed next experiment

Ask the user to challenge the reasoning when their system knowledge could change the hypothesis ranking. Trivial read-only observations may be performed without stopping.

After each experiment, record the result and update the hypotheses from the result before selecting the next experiment.

### 6. Do not fix before diagnosing

Do not propose a permanent change merely because it might make the symptom disappear.

Distinguish explicitly between:

- **Root cause:** the mechanism demonstrated to produce the problem.
- **Fix:** a change that removes the root cause.
- **Mitigation:** a change that reduces the impact without removing the root cause.
- **Workaround:** a way to avoid triggering the problem.

If evidence is insufficient to establish root cause, say so. A change made before diagnosis must not be described as a confirmed fix.

### 7. Challenge the final conclusion

Before declaring the problem solved, perform one final adversarial review:

- What evidence actually demonstrates this root cause?
- What evidence would we expect but have not observed?
- Could the fix have hidden the symptom without fixing the cause?
- Is there another explanation consistent with all observations?
- Can the failure be reproduced before the fix and prevented after it?

Do not confuse “the problem disappeared” with “the hypothesis was proven.”

## Interaction format

During investigation, prefer concise checkpoints such as:

```text
Objective
- ...

Constraints and explicit requests
- ...

Observations
- ...

Assumptions
- ...

Unknowns
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

## Default behavior

When invoked:

1. parse the prompt into the user's objective, constraints, explicit experiment requests, and unverified opinions
2. inspect available evidence and frame observations, assumptions, and unknowns
3. propose, rank, and try to falsify competing hypotheses
4. select one experiment, explain its expected discriminating result, and update the hypotheses from the outcome
5. discuss the reasoning with the user and only then recommend or implement a permanent fix

Optimize for **information gained per experiment**, not actions performed per session.
