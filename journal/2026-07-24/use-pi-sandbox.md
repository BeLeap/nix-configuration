# Replace pi-landstrip with pi-sandbox

- Replaced the pinned `pi-landstrip` Pi package with `pi-sandbox` 0.6.1 from
  `carderne/pi-sandbox`.
- Added Nix's `ripgrep` package only to the wrapped Pi process's `PATH` because
  `pi-sandbox` checks for the `rg` executable when initializing its sandbox
  runtime. It is deliberately not installed as a global home package.
- Removed the obsolete `network.allowNetwork` setting from the sandbox
  configuration; an empty `allowedDomains` list retains the deny-by-default,
  prompt-on-access behavior in `pi-sandbox`.

## Validation

- Parsed `config/recipe/pi/sandbox.json` with `jq` successfully.
- `git diff --check` completed successfully.
- Could not run `nix fmt -- --check .` or `nix flake check --no-build`
  because the execution environment does not provide the `nix` executable.
