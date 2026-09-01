# Add Nix tool fallback to agent instructions

Added guidance for coding agents to use `nix shell` when a required CLI or
development tool is unavailable, rather than skipping the affected check or
installing the tool globally.

Validated the change with `git diff --check`.

## Follow-up

Generalized the instruction from unavailable "CLI or development tool" to any
required tool. Also generalized "check" to "related work" so the guidance applies
beyond validation tasks.
