# Diagnose Podman launchd autostart

## Outcome

- Diagnosed macOS Podman autostart failure in `config/recipe/podman/default.nix`.
- The Home Manager LaunchAgent ran `podman machine start`, but launchd killed the spawned `vfkit` VM when the one-shot starter exited because `AbandonProcessGroup` was unset.
- Reproduced this with `launchctl kickstart`: the job exited 0, then the machine became `stopped` and the API socket refused connections.
- Added `AbandonProcessGroup = true` to the Podman LaunchAgent configuration.

## Validation

- A temporary LaunchAgent with `AbandonProcessGroup = true` kept the VM running for 60 seconds and `podman info` succeeded.
- The corrected real LaunchAgent was tested after stopping the machine: it exited 0, the VM remained `running` for 60 seconds, and `podman info` succeeded.
- Nix parsing and Alejandra formatting passed for `config/recipe/podman/default.nix`.
- The full `nh darwin switch` attempted to build unrelated static packages for more than 20 minutes and was stopped. The active LaunchAgent plist was nevertheless updated and currently contains `AbandonProcessGroup = true`; the Home Manager profile symlink still points to the previous generation and should be reconciled by a later successful switch.

## Reusable lesson

For a launchd job that starts a long-lived child and then exits successfully, set `AbandonProcessGroup = true`; `RunAtLoad` alone is insufficient when launchd owns the child process group.
