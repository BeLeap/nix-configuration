# try Zellij

- Swapped the development recipe from `tmux` to a new `zellij` recipe.
- Added `config/recipe/zellij/default.nix` to install Zellij and manage a minimal `zellij/config.kdl`.
- Updated Ghostty to start `zellij attach --create sp` instead of `tmux new-session -As sp`.
- Checked the packaged Zellij CLI; version `0.44.3` supports `zellij attach --create <session>`.
- After applying the config and returning in Zellij, the environment reported `TERM=xterm-ghostty`, `TERM_PROGRAM=ghostty`, `ZELLIJ_SESSION_NAME=sp`, and no `TMUX`.
- `zellij run` from opencode's tool process initially failed with `There is no active session!` because `ZELLIJ_SOCKET_DIR` was not exported. The live server socket was under `/var/folders/76/cyb4v3j909v8my1yh21m0st00000gn/T/zellij-501`.
- With `ZELLIJ_SOCKET_DIR` set, `zellij run` successfully created a pane and emitted Ghostty `OSC 9`, but no notification appeared.
- Zellij docs/config show explicit OSC8 hyperlink and OSC52 clipboard handling, but no arbitrary OSC passthrough option, so Zellij does not currently solve opencode OSC 9 notifications in this setup.
- Ghostty/macOS logs confirmed the split: a direct no-multiplexer Ghostty `OSC 9` test produced `com.apple.UserNotifications` entries including `Adding notification request`, while the Zellij-pane `OSC 9` test produced no matching Ghostty notification request. This indicates Ghostty works and Zellij is not forwarding/allowing the notification OSC sequence through to Ghostty.
