# tmux fish fallback

- Updated `config/recipe/tmux/default.nix` so tmux uses Bash as `default-shell`.
- Added a `default-command` that starts login Fish first and falls back to `bash --noprofile` if Fish exits with a failure status during startup.
- This prevents a tmux pane from closing immediately when Fish cannot be executed or exits non-zero during startup.
