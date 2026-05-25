# codex approval focus hook

- Updated `config/recipe/codex/default.nix` to add a Codex `PermissionRequest` hook.
- The hook runs a Nix-managed `focus-codex-approval` shell application.
- On approval requests, the script selects the current Codex tmux pane using `CODEX_TMUX_TARGET` when set, then falls back to `$TMUX_PANE`.
- On macOS, it activates the terminal app via `osascript`, with explicit cases for Terminal, iTerm, WezTerm, and Ghostty.
- Enabled Codex TUI notifications for `approval-requested` and `agent-turn-complete`.
- Verification:
  - `nix run nixpkgs#alejandra -- config/recipe/codex/default.nix`
  - `nix eval .#darwinConfigurations.beleap-m1air.config.system.build.toplevel.drvPath --raw`
