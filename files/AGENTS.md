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

- Do not hide, swallow, or ignore errors just to keep things running.
- Prefer explicit failures with clear error messages over silent fallbacks.
- Surface error states in logs/output/UI so failures are easy to notice and debug.
- If a temporary workaround is unavoidable, document the limitation and the real failure clearly.

# Architecture

- Follow a tidy-first approach in code and system design decisions.
- Leave code cleaner than you found it while preserving behavior.
- Prefer cohesive, well-factored designs with clear boundaries and minimal complexity.
- Adopt a broad **design for changeability** principle across all work, not just code: architecture, configuration, operations, and workflows should all stay easy to modify.
  - Example (operational changeability): for long-running commands/processes, prefer approaches that are interruptible and restartable (or resumable) so changes can be applied safely without starting over.

# Journal

- Record work history and any information useful for the next task in
  `journal/<date>/<appropriate_title>.md`.
- Note: a coding agent is actively recording entries in `journal/`, so treat it as
  an existing source of task history and operational context.
