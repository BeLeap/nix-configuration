# Version control

- I use **Jujutsu (`jj`)** as my primary VCS workflow.
- Prefer `jj` commands over `git` commands for day-to-day version control tasks.
- Only use `git` when explicitly requested, or when a task/tool strictly requires it.
- Keep commits **atomic**: each commit should contain one logical change, with a clear
  message describing that single intent.

# Error handling

- Prefer failing safely over pursuing success at any cost.
- Do not hide, swallow, or ignore errors just to keep things running.
- Prefer explicit failures with clear error messages over silent fallbacks.
- Surface error states in logs/output/UI so failures are easy to notice and debug.
- If a temporary workaround is unavoidable, document the limitation and the real failure clearly.

# Assumptions

- Review the relevant files and existing patterns before editing.
- Identify assumptions, verify them when possible, and state those that affect
  the approach. Ask when an unresolved ambiguity would materially change the
  result; otherwise use the simplest reasonable interpretation.

# Tool availability

- When a required tool is unavailable, use Nix to run it (for example,
  `nix shell nixpkgs#<package> --command <tool>`) instead of skipping the related
  work or installing the tool globally.

# Architecture

- Consider structural improvements when they directly advance the requested
  outcome, and prefer the smallest cohesive design that solves it.
- Keep edits focused on the request. Avoid speculative features, abstractions,
  and unrelated refactors or formatting changes.
- Preserve behavior and style. Clean up only code made unnecessary by your own
  changes; don't remove unrelated existing code.
- Adopt a broad **design for changeability** principle across all work, not just code: architecture, configuration, operations, and workflows should all stay easy to modify.
  - Example (operational changeability): for long-running commands/processes, prefer approaches that are interruptible and restartable (or resumable) so changes can be applied safely without starting over.

# Goal-Driven Execution

- For multi-step work, state a brief plan and how completion will be checked.
- Run checks relevant to the changed area and follow the project-specific
  workflow where documented.
- Report which checks ran and any failures or limitations; don't claim that
  unchecked work passed.

These working principles are adapted in part from
[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md).

# Journal

- Record work history and any information useful for the next task in
  `.journal/<date>/<appropriate_title>.md`.
- Treat journal entries as append-only: append new information to an existing entry
  instead of rewriting or deleting its prior contents. Record corrections as new
  notes so the original history remains visible.
- Include, when applicable:
  - outcome and significant changes;
  - validation performed, including failures or blocked checks;
  - unexpected findings, recurring patterns, or reusable lessons;
  - unresolved limitations and recommended follow-up work.
- Do not invent retrospective findings merely to fill every category; omit sections
  that have nothing useful to record.
- Before related work, search relevant journal entries for prior context and lessons.
- Treat journal entries like ordinary files for version control; do not force-add them if they are ignored.
- Note: a coding agent is actively recording entries in `.journal/`, so treat it as
  an existing source of task history and operational context.
