# Diagnose WTS session-switch hang

`wts` completed `try` and selected `/Users/beleap/ws/2026-11-13-test`. The live process then blocked in `zellij action switch-session`.

Evidence:
- `zellij list-sessions` returned, and WTS created the target session.
- The process stack stayed in Zellij's `connect_to_server` retry loop.
- Zellij 0.46.0 had the active `sp` session socket at `b255f0d79ab3`. The socket named `sp` did not exist.
- `ZELLIJ_SESSION_NAME=sp zellij action dump-layout` blocked. Setting it to `b255f0d79ab3` returned the layout.
- The session index maps logical name `sp` to socket ID `b255f0d79ab3`.

No source files changed. WTS needs a reliable way to resolve the current session socket ID before it runs `zellij action`, or a Zellij version that resolves the logical session name correctly. The existing WTS process was left running.

## Follow-up: shell process after switching

The successful retry ended the blocked WTS process. Source shell PID `80439` remained a child of Zellij server PID `27140`. Target shell PID `80512` was a child of target server PID `80500`. The process tree showed no Zsh nested under another Zsh.

Target shell PID `80512` had `SHLVL=2`. `config/recipe/starship/default.nix` displays `$shlvl` when the level is at least `2`, so the prompt can show `[2]`. Other inspected Zsh processes did not export `SHLVL`. The Bash wrapper likely adds the displayed shell level when it creates a session with `zellij attach --create-background`. The source script needs a focused test before any change.

A follow-up environment check found `SHLVL=2` in the target Zellij server itself. The source server did not export `SHLVL`. This confirms that the extra level exists before the target Zsh starts. The target session was newly created, so this finding applies to WTS session creation rather than switching into an existing session.

## Follow-up: fix WTS action routing

`config/recipe/overlay/pkgs/beleap-utils/scripts/wts` now walks its parent process chain to find the active Zellij server socket ID. It passes that ID as `ZELLIJ_SESSION_NAME` only to `zellij action switch-session`. The change does not alter `SHLVL`.

`bash -n`, ShellCheck, three mocked cases, and a focused `beleap-utils` Nix build passed. The first mock assertion incorrectly expected the socket ID on `attach`; the corrected test passed. The built package is `/nix/store/ssnq091051qvphrhxbw75c67gspvh5ji-beleap-utils`. The active profile still points to the old package, and no Nix switch ran.

`wzs` still sends the logical session name to `zellij action switch-session`. It may need the same resolver in a separate change.

## Follow-up: confirm `SHLVL` origin

A controlled Zellij pane recorded `SHLVL=1` in its invoking Zsh and launcher environment. The WTS Bash entrypoint then passed `SHLVL=2` to mocked `zellij attach --create-background` and `zellij action`. This confirms that the Bash entrypoint increments the level before the target server starts. The target server's previously observed `SHLVL=2` matches this path. WTS does not start a nested Zsh, and no `SHLVL` adjustment is needed to identify the cause.

The first probe timed out because normal Zsh startup replaced the mock `PATH` and launched the real `try` selector. I stopped that probe's processes. The successful rerun used `zsh -f` and exported mock Bash functions, so it did not call real Zellij attach or switch actions.

The active profile still points to the old WTS package. The source fix is built but is not active until the configuration is switched.

## Follow-up: simplify session routing

The process-ancestor resolver from the earlier WTS fix is removed. On Zellij 0.46.0, `ZELLIJ_SESSION_NAME=sp zellij --session sp action dump-layout` returned successfully. WTS now passes the logical current session name through Zellij's global `--session` option for `switch-session`.

The corrected mock recorded `zellij --session sp action switch-session ...` and completed without a real session switch. `bash -n`, ShellCheck, and a focused `beleap-m1air` `beleap-utils` Nix build passed. The first mock rejected the new leading option because it expected `action` first; the corrected mock passed. No live session switch or `nh darwin switch` ran, so the active profile still uses the old package.
