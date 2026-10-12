# Run Nix garbage collection after runner jobs

- Configured the `beleap-macmini` GitHub Actions runner to run `nix-store --gc` from the runner's job-completed hook. The hook runs after all workflow steps, including both revision builds and closure diff generation, and logs/fails explicitly if garbage collection fails.
- Validation passed: Nix parsing, evaluation of the configured hook path and full `beleap-macmini` system derivation path, plus Alejandra formatting check.

## Follow-up

- Replaced the runner-level hook with an explicit `always()` garbage-collection step in the self-hosted build job, at the user's preference. It runs after each matrix job's build and diff steps when Nix setup succeeded; the initial hook validation above describes the superseded implementation.
- Workflow lint passed with actionlint after ignoring its pre-existing warnings that the custom `beleap-macmini` runner label is unknown to actionlint.
