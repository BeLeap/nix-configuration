# Resolve conflict in PR 288

- Rebased `gc-after-runner-builds` onto the current `master`, preserving the new `nix-community/cache-nix-action@v7` step and adding the `install_nix` step ID required by the cleanup condition.
- Scoped `nix store gc` to the `beleap-macmini` runner, matching the pull request description.
- `actionlint` passed for `.github/workflows/build.yml` when ignoring its existing warnings about the custom `beleap-macmini` runner label.
