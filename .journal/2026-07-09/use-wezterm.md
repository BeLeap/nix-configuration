# use WezTerm

- Switched the development terminal recipe from the Ghostty/Zellij trial to `wezterm`.
- Added `config/recipe/wezterm/default.nix` with a managed `wezterm.lua` sourced from `config/recipe/wezterm/wezterm.lua` for readability.
- Configured WezTerm to use zsh as the default program, workspace `sp`, Gruvbox Dark, Caskaydia Cove Nerd Font Mono, opacity/padding similar to the previous Ghostty setup, and tmux-like `Ctrl-a` leader bindings.
- Updated the macOS Dock entry to `WezTerm.app` and changed the Aerospace terminal app-id rule to `com.github.wez.wezterm`.
- Added `wzs` and `wzsf` utility scripts for WezTerm workspace switching/fuzzy selection. `tms` and `tmsf` now delegate to those scripts for compatibility during the tmux-to-WezTerm migration.
- Reworked `wzs` to operate on WezTerm workspaces only (`wezterm start --workspace <name>`), not tabs/panes. Added `Leader+s` to open WezTerm's native fuzzy workspace/session switcher.
- Removed the now-unused `config/recipe/tmux/default.nix`; no remaining config recipe references pointed to tmux.
