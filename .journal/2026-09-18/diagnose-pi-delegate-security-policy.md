# Diagnose Pi delegate security-policy block

## Outcome

- Confirmed the failure is emitted by ZeroClaw 0.8.5, not by the Pi child and not by the Nix executable permission bits.
- The live `pi_delegate__start` call failed before spawning the runner with:
  `Path blocked by security policy: /nix/store/sqpk0vnj13nqqs2d2v8h6x5fa0ip3npq-zeroclaw-pi-delegate/bin/zeroclaw-pi-delegate`.
- The active risk profile is `supervised`, with `workspace_only = true`, zero configured `allowed_roots`, and `zeroclaw-pi-delegate` present in `allowed_commands`. The ZeroClaw workspace is `/Users/beleap/.zeroclaw/agents/default/workspace`.

## Cause

- The generated `pi_delegate` skill hardcodes the Nix store path in each shell tool command.
- ZeroClaw's POSIX shell path scanner treats the first token of that command as a path because it begins with `/`.
- A bare command-name entry in `allowed_commands` does not exempt an absolute path. Since `/nix/store/...` is outside the ZeroClaw workspace and no allowed root covers it, the shell tool returns the path-policy error before command spawn.
- The requested Pi `yolo` mode is unrelated to this rejection. `PI_PERMISSION_MODE=yolo` would affect the child Pi process only after the parent ZeroClaw shell tool launches it. The runner's `--no-approve` flag controls Pi project trust, not ZeroClaw's shell policy.

## Validation

- `zeroclaw security status --agent default` confirmed supervised mode, `workspace_only = true`, and active macOS `sandbox-exec`.
- The installed runner is executable and `zeroclaw-pi-delegate --help` reaches the script.
- The daemon LaunchAgent `PATH` contains `/etc/profiles/per-user/beleap/bin`, and that PATH resolves `zeroclaw-pi-delegate` by name.
- Upstream ZeroClaw 0.8.5 source confirms the shell tool applies `forbidden_workspace_path_argument_for_shell` before `cmd.spawn()`. A bare executable name avoids the path-like first-token check; an exact path-shaped `allowed_commands` entry or an applicable `allowed_roots` entry can authorize an absolute path.

## Recommended fix

Change the generated skill commands from the substituted absolute runner path to the bare `zeroclaw-pi-delegate` command. The active daemon PATH already exposes the profile bin directory, and the existing bare command allowlist entry remains appropriately narrow. Rebuild and activate the Nix configuration, then retry `pi_delegate__start`.

Do not solve this by disabling `workspace_only` globally or allowing all of `/nix/store`; both broaden the ZeroClaw security boundary unnecessarily. If an absolute path must be retained, allow only the exact generated runner path and re-render that allowlist on every Nix rebuild.

## Scope

No security policy, daemon, skill, or delegate task was changed during this diagnosis. Only this append-only journal entry was added.

## 2026-09-18 — Applied narrow configuration fix

- Changed `config/recipe/zeroclaw/pi-delegate-skill.toml` so `start`, `status`, and `cancel` invoke the bare `zeroclaw-pi-delegate` command.
- Removed the obsolete `@runner@` Nix-store-path substitution from `config/recipe/zeroclaw/default.nix`.
- TOML parsing, Nix parsing, and `nix build .#darwinConfigurations.beleap-macmini.system --no-link` passed.
- The generated skill artifact contains only bare runner commands.
- The live daemon was not activated; it still uses the previous generated skill until Darwin/Home Manager activation.

## 2026-09-18 — Activation verified

- The new LaunchAgent was loaded but had not spawned (`runs = 0`), so its already-activated service was kickstarted once.
- The running ZeroClaw daemon now uses the generated skill with bare `zeroclaw-pi-delegate` commands; the live service is running under LaunchAgent `org.nix-community.home.zeroclaw`.
- `zeroclaw-pi-delegate status` returned `No Pi delegation is waiting.` No delegation was started.

## 2026-09-18 — Daemon non-start diagnosis

- The Home Manager activation script's LaunchAgent handler calls `launchctl bootout`, installs the plist, and calls `launchctl bootstrap`; it does not call `launchctl kickstart`.
- At activation time, launchd logged `service inactive`, removed the old job, then reported `pending spawn, domain in on-demand-only mode` while the bootstrap still returned success.
- The resulting service state was `not running`, `runs = 0`, and `last exit code = (never exited)`. This rules out a ZeroClaw crash or configuration failure: the daemon process had not run at all.
- A manual `launchctl kickstart -k gui/501/org.nix-community.home.zeroclaw` started the already-loaded job. It reached `running`, copied the new skill, and remains active.
- Best-supported explanation: this activation encountered a launchd/Home Manager bootstrap lifecycle quirk where `RunAtLoad` did not trigger the initial spawn. The service's `KeepAlive` and `RunAtLoad` settings are present; no ZeroClaw code change caused the stop.
