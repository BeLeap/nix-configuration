# Run Nix garbage collection after runner jobs

- Configured the `beleap-macmini` GitHub Actions runner to run `nix-store --gc` from the runner's job-completed hook. The hook runs after all workflow steps, including both revision builds and closure diff generation, and logs/fails explicitly if garbage collection fails.
- Validation passed: Nix parsing, evaluation of the configured hook path and full `beleap-macmini` system derivation path, plus Alejandra formatting check.

## Follow-up

- Replaced the runner-level hook with an explicit `always()` garbage-collection step in the self-hosted build job, at the user's preference. It runs after each matrix job's build and diff steps when Nix setup succeeded; the initial hook validation above describes the superseded implementation.
- Workflow lint passed with actionlint after ignoring its pre-existing warnings that the custom `beleap-macmini` runner label is unknown to actionlint.

## Follow-up: keep a rolling GitHub Actions Nix cache

- Added `nix-community/cache-nix-action` restore/save steps to hosted macOS build jobs. Pull requests restore the default-branch cache without writing one; successful pushes save a run-specific cache and purge older macOS cache keys for that workflow ref.
- Limited cached store growth to a 5 GiB target before saving. Kept the current build output as a GC root and remove the base output root after closure comparison so stale store paths can be collected.
- Kept explicit `nix store gc` for the persistent self-hosted runner; hosted jobs now rely on cache-action GC before save.
- Reviewed the workflow diff manually. No GitHub Actions run was started, so action behavior and cache restore/save remain to be confirmed by CI.
