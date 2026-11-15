# Fix `wts` session routing

- `wts` inherited `ZELLIJ_SESSION_NAME=sp`, but the active session list did not contain `sp`.
- The current Zellij server used ID `b255f0d79ab3`. `wts` passed `sp` to `--session`, so Zellij rejected the switch.
- `wts` now finds the current Zellij server ID through its parent process chain and uses that ID for `switch-session`.
- If `ZELLIJ_SESSION_NAME` is set but no Zellij server appears in the process chain, `wts` reports an error and exits.

## Validation

- `bash -n` passed for `wts`.
- ShellCheck passed for `wts`.
- Mocked tests passed for switching from the stale `sp` value, creating a missing target session, attaching outside Zellij, and rejecting stale context without a server.
- `zellij --session b255f0d79ab3 action dump-layout` passed.
- The focused `beleap-utils` Nix build passed at `/nix/store/gc09mx1q33npfm63vmyl9splfgk3qx2p-beleap-utils`.
- No live session switch or Darwin system activation ran.

## Follow-up: remove the workspace-session command family

- Removed `wts`, `wzs`, and `wzsf` from `beleap-utils`.
- Restored `jws` in `config/recipe/zsh/default.nix` at the user's request.
- Kept the standalone `try` recipe and the Zellij/Rio configuration.
- The earlier section records an intermediate WTS fix. The final configuration no longer installs `wts`.
- Rebuilt `beleap-utils` at `/nix/store/vn3rhyqr96m6wcvjfy39nkbj5yy0bs0n-beleap-utils`. The build omits `wts`, `wzs`, and `wzsf`, while retaining `crcpr`.
- Darwin system evaluation passed with `nix eval --raw .#darwinConfigurations.beleap-m1air.system.drvPath --accept-flake-config`.
- A parallel Nix evaluation first hit a busy cache. A sequential retry passed.
- The installed `jj diff` command does not support `--check`. I reviewed the final diff manually.
