# Automate Pi delegation after approval

## Outcome

Updated the Nix-managed `pi_delegate` skill to keep one explicit `pi_delegate.start` approval while automating the remaining workflow. After approval, ZeroClaw now has instructions to stage the task, use `/Users/beleap/ws` instead of the protected `.zeroclaw` workspace, let Pi clone a repository URL when needed, start Pi, poll status while it is running, and surface the final report.

The generated daemon now creates `/Users/beleap/ws`, injects that path into the skill, and allows a longer delegated response window: 16 tool iterations and 600 seconds. The existing supervised policy remains unchanged: `pi_delegate.start` and `pi_delegate.cancel` still require approval, and `workspace_only = true` remains enabled.

## Validation

- Shell syntax check passed for `pi-delegate-runner.sh`.
- Python TOML parsing passed for `pi-delegate-skill.toml`.
- Alejandra formatting check passed for the modified Nix file.
- Statix check passed for the modified Nix file.
- Darwin system evaluation passed.
- Full `darwinConfigurations.beleap-macmini.system` build passed.
- Inspected generated skill, config, and daemon outputs; the project root and manual approval settings rendered as intended.

## Limitation

The Nix generation and daemon activation were not applied to the running service. A Darwin/Home Manager activation is still required before the updated skill is used by ZeroClaw.

## Follow-up diagnosis

The live skill was updated, but the existing `.pi-delegate/cwd` still pointed to `/Users/beleap/.zeroclaw/workspace`. The runner previously failed on that stale protected path. Added a managed-root fallback and an execution preamble: protected or missing staged targets use `/Users/beleap/ws`, and Pi is instructed to clone remote repositories there when needed. A fake-Pi integration check passed for the protected-path fallback and task preamble. The Darwin build passed again after this follow-up.

Activation was attempted with `darwin-rebuild switch --flake .#beleap-macmini` but was blocked because this host now requires system activation to run as root.
