# Setup helm-ls for Helix

## Summary
- Added a Helix language server entry for Helm (`helm-ls`) and configured it to run with the `serve` subcommand.
- Registered Helix's `helm` language to use the new language server and detect projects by `Chart.yaml`.

## Notes
- This change wires Helm chart editing in Helix to `helm-ls` via Home Manager-managed Helix language server settings.
