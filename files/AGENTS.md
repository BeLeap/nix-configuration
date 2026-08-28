# MCPs

- Always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP
tools to resolve library id and get library docs without me having to explicitly ask.

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

- Question every assumption: identify what is being assumed and why, verify it
  when possible, and prefer designs that eliminate or minimize reliance on
  assumptions.

# Tool availability

- When a required tool is unavailable, use Nix to run it (for example,
  `nix shell nixpkgs#<package> --command <tool>`) instead of skipping the related
  work or installing the tool globally.

# Architecture

- Always consider structural enhancement first.
- Follow a tidy-first approach in code and system design decisions.
- Leave code cleaner than you found it while preserving behavior.
- Prefer cohesive, well-factored designs with clear boundaries and minimal complexity.
- Adopt a broad **design for changeability** principle across all work, not just code: architecture, configuration, operations, and workflows should all stay easy to modify.
  - Example (operational changeability): for long-running commands/processes, prefer approaches that are interruptible and restartable (or resumable) so changes can be applied safely without starting over.

# Journal

- Record work history and any information useful for the next task in
  `journal/<date>/<appropriate_title>.md`.
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
- Do not force add journal entries to version control.
- Note: a coding agent is actively recording entries in `.journal/`, so treat it as
  an existing source of task history and operational context.
