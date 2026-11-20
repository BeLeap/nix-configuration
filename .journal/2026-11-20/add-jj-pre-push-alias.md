# Add jj-pre-push alias

Updated the managed Jujutsu configuration so `jj push` runs `jj-pre-push push` through `uvx`; the existing `jj p` shortcut now delegates to `jj push`.

Validation was limited to reviewing the configuration diff. This workspace has no `jj`, `nix`, or `alejandra` executable, so the config could not be evaluated here. The alias still needs the Home Manager configuration to be rebuilt/applied on the user's machine. Gitleaks is not yet wired into repository checks: its upstream pre-commit hook scans Git's staged index, which is not jj's change model, so using it unverified could silently miss pushed changes.

## Gitleaks integration

Added a repository-local pre-commit hook that `jj-pre-push` can run for files in the outgoing bookmark diff. It calls `gitleaks dir` once per existing path rather than the upstream Git-staged hook, so it checks jj's checked-out file contents. Deleted paths are skipped because they have no working-tree contents; this also means this check does not inspect deleted content in commit history. The repo must have `gitleaks` on PATH and the pushed revision must include `.pre-commit-config.yaml` plus `scripts/gitleaks-files.sh` for the check to run.
