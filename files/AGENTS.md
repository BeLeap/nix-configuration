# MCPs

- Always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP
tools to resolve library id and get library docs without me having to explicitly ask.

# Version control

- I use **Jujutsu (`jj`)** as my primary VCS workflow.
- Prefer `jj` commands over `git` commands for day-to-day version control tasks.
- Only use `git` when explicitly requested, or when a task/tool strictly requires it.

# Error handling

- Do not hide, swallow, or ignore errors just to keep things running.
- Prefer explicit failures with clear error messages over silent fallbacks.
- Surface error states in logs/output/UI so failures are easy to notice and debug.
- If a temporary workaround is unavoidable, document the limitation and the real failure clearly.
