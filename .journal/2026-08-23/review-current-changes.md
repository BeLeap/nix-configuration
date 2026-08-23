# Review current changes

## Outcome

- Reviewed the recipe-graph migration, recipe declarations, system assembly, flake checks, and host option smoke checks.
- No functional findings identified in the current working-copy changes.

## Validation

- `nix flake check --no-build --all-systems --show-trace` passed.
- Pure graph tests evaluated successfully.
- Darwin Home Manager smoke checks confirmed username, Bash, Discord, and Syncthing options.
- NixOS 1Password system option evaluation succeeded.

## Notes

- Existing Home Manager default-change warnings remain; this review found no new warnings attributable to the migration.
- No system build or switch was performed.

## Additional probe

- An exploratory all-entrypoint probe that deep-forced every module value hit Nix's max-call-depth while forcing the recursive `agenix.nixosModules.default` value. This probe was not used as a pass/fail result; the actual flake checks and type-only declaration validation passed.

## Concern-boundary review

- The pure graph boundary is clear: `lib/recipe-graph.nix` owns declaration validation, traversal, cycle detection, and stable deduplication; `config/recipe-assembly.nix` owns filesystem resolution and Home Manager aggregation.
- Boundary concerns remain outside the graph: `lib/mkSystem.nix` still injects the full `callPackage` scope as `inputs`, recipe discovery is filesystem-based rather than registry-based, and `config/recipe/` still mixes profiles, host implementations, overlays, and package derivations.
- `config/recipe/beleap-macmini/default.nix` still contains reusable Ollama/ZeroClaw daemon implementation beside host-specific choices. `config/recipe/default/default.nix` still hides development, desktop, and Kubernetes policy behind one broad profile. Hosts still manually pair shared and platform-specific 1Password recipes.
- These are architectural follow-ups, not runtime regressions in this migration. No source configuration was changed by this review.

## Boundary-review validation

- `nix flake check --no-build --show-trace`: passed; existing Home Manager default-change warnings remain.
- The parameterized graph tests evaluated successfully with `nix eval`; all five host derivation paths evaluated successfully.
- `alejandra --check .` and `statix check .`: passed. `deadnix .` exits successfully but reports the existing unused input arguments in `lib/mkSystem.nix` and three smaller recipe warnings.
