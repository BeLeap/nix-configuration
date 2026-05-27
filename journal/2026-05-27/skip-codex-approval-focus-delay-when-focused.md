# skip codex approval focus delay when focused

- Updated `config/recipe/codex/default.nix` so the Codex approval focus hook skips the 5 second delay when Codex is already focused.
- The hook now treats Codex as already focused when:
  - the target tmux pane is both the active pane and in the active window
  - Aerospace's focused workspace is `1`, where the terminal is expected to live
- Replaced terminal-app activation through `osascript` with `aerospace workspace 1`.
- Changed the hook status message from `Focusing Codex approval in 5 seconds` to `Focusing Codex approval if needed`.
- Updated the trusted hook hash to `sha256:9cce3fe8ad0b126b86b28202c0d7c9d5791e68a0ec516c954637342ecee050c4`.
