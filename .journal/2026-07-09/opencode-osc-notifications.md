# opencode OSC notifications

- Tested direct OSC 9 notification escape from the current opencode environment with `printf '\\033]9;opencode OSC notification test from current environment\\007'`.
- Current terminal environment reported `TERM=tmux-256color` and `TERM_PROGRAM=tmux`.
- No generated `~/.config/opencode/tui.json` was present before this change.
- A direct write to `~/.config/opencode/tui.json` was blocked, and the file is managed by this Nix configuration anyway.
- Updated `config/recipe/opencode/default.nix` to enable opencode TUI attention notifications and sound through `programs.opencode.tui.attention`.
- opencode loads config at startup, so the running session must be restarted after applying the Home Manager/Nix configuration.
