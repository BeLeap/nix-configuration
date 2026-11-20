# Add jj-pre-push alias

Updated the managed Jujutsu configuration so `jj push` runs `jj-pre-push push` through `uvx`; the existing `jj p` shortcut now delegates to `jj push`.

Validation was limited to reviewing the configuration diff. This workspace has no `jj`, `nix`, or `alejandra` executable, so the config could not be evaluated here. The alias still needs the Home Manager configuration to be rebuilt/applied on the user's machine. Gitleaks is not yet wired into repository checks: its upstream pre-commit hook scans Git's staged index, which is not jj's change model, so using it unverified could silently miss pushed changes.

## Gitleaks integration

Added a repository-local pre-commit hook that `jj-pre-push` can run for files in the outgoing bookmark diff. It calls `gitleaks dir` once per existing path rather than the upstream Git-staged hook, so it checks jj's checked-out file contents. Deleted paths are skipped because they have no working-tree contents; this also means this check does not inspect deleted content in commit history. The repo must have `gitleaks` on PATH and the pushed revision must include `.pre-commit-config.yaml` plus `scripts/gitleaks-files.sh` for the check to run.

## Follow-up

Switched the `jj-pre-push` alias from `uvx` to the packaged `pkgs.unstable.jj-pre-push`, so Home Manager installs and runs a pinned Nix package without a runtime package download.

The initial checker config was repository-local. It has now been moved into the Jujutsu Home Manager recipe and passed explicitly to `jj-pre-push --config`, so the Gitleaks scan applies across repositories. The helper is installed as a Home Manager package with Gitleaks on its runtime PATH.
