# fix WezTerm workspace scripts

- Investigated `wzs`/`wzsf` failure from `beleap-utils`.
- Root cause: the custom macOS WezTerm derivation only exposed `wezterm` in `$out/bin`, but `wezterm start --workspace ...` execs sibling helper binaries such as `wezterm-gui`.
- Updated the WezTerm install phase to symlink `wezterm`, `wezterm-gui`, and `wezterm-mux-server` into `$out/bin`.
- Follow-up: `wezterm start --workspace ...` also blocks while the spawned window is alive. Switched `wzs` to `wezterm cli spawn --new-window --workspace ...`, which returns immediately.
- Follow-up: `wzsf` looked stuck when only one workspace existed because `fzf` still opened interactively. It now auto-selects a single workspace and only opens `fzf` for multiple workspaces.
- Follow-up: neither spawning a window nor `activate-pane` changed the GUI client's active workspace in the packaged WezTerm version. Added a `wezterm.lua` `user-var-changed` bridge so `wzs` emits `SetUserVar=WEZTERM_WORKSPACE=...` and the config calls `wezterm.mux.set_active_workspace`.
- Follow-up: removed runtime `command -v jq` checks from `wzs`/`wzsf`; `beleap-utils` now wraps scripts with the Nix-provided `jq` on `PATH`.
