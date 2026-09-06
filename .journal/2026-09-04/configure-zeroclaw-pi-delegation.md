# Configure ZeroClaw Pi delegation

## Outcome

Replaced the uncommitted MCP prototype with a Nix-managed ZeroClaw `pi_delegate` skill for the beleap-macmini recipe. The skill is copied into `~/.zeroclaw/workspace/skills/pi_delegate/SKILL.toml` by the generated daemon before ZeroClaw starts, and the runner is installed as `zeroclaw-pi-delegate`.

The skill stages a self-contained task and target directory, starts Pi asynchronously, and exposes status/cancel operations. Pi is invoked with argv (not a shell), `--no-session`, `--no-approve`, and `--print`. Target directories are canonicalized under the home directory and protected locations are rejected. Task and output sizes are bounded; failures, timeouts, and cancellations are reported.

ZeroClaw remains supervised. `pi_delegate.start` and `pi_delegate.cancel` require approval; `pi_delegate.status` and `read_skill` are auto-approved. Existing Ollama, workspace-only, forbidden-path, high-risk-command, rate, and shell-timeout safety settings remain explicit in the generated config.

## Validation

- `sh -n` and Python TOML parsing passed for the source files.
- `shellcheck`, `statix`, `deadnix`, and repository-wide Alejandra formatting passed.
- Darwin configuration evaluation passed.
- Full `darwinConfigurations.beleap-macmini.system` build passed.
- ZeroClaw loaded the generated skill, listed `start/status/cancel`, and passed the skill audit.
- Generated-config parsing and approval settings passed.
- Fake-Pi tests passed for successful execution, cancellation, and command-injection resistance.

`nix flake check --no-build` remains blocked by the existing cross-platform `poke-token-bar` package: it is aarch64-darwin-only while the check evaluates `aarch64-linux`. No activation or commit was performed.
