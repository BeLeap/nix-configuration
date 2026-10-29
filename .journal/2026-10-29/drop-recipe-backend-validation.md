# Drop recipe backend validation

## Outcome

- Removed `validateBackend` and its `nixos`/`darwin` whitelist from `lib/recipe-graph.nix`.
- `modulesForBackend` now passes the selector directly to `builtins.getAttr`.
- Removed the dedicated `invalidBackend` test from `tests/recipe-graph.nix`.

## Validation

- Focused recipe-graph evaluation passed with `nix eval --raw .#checks.aarch64-darwin.recipe-graph.drvPath`.
- `nix-instantiate --parse` passed for both changed Nix files.
- `alejandra --check lib/recipe-graph.nix tests/recipe-graph.nix` passed.
- `nix flake check --no-build --all-systems --show-trace` failed during NixOS configuration evaluation. The evaluator could not realize the `starship-1.25.1.drv` store path while reading `config/recipe/starship/default.nix`.
