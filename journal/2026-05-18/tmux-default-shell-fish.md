# tmux default shell fish

- Debugged why tmux load paths could open Bash instead of Fish.
- Current tmux config set `default-shell` to Bash and used `default-command` to try Fish with a Bash fallback.
- A temporary tmux session confirmed Fish starts correctly, so the fallback is not needed for the current environment.
- Preserved Bash as the emergency `default-shell`.
- Updated `default-command` to enable Bash `execfail`, `exec` Fish first, and only continue to Bash if Fish cannot be executed.
- This avoids dropping into Bash after a normal Fish session exits with a non-zero status.
