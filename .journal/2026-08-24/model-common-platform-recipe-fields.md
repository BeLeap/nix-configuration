# Model common and platform recipe fields

## Outcome

- Replaced the strict recipe declaration fields `systemModules` and `homeModules` with common `system` and `home` lists plus `nixos` and `darwin` fragments.
- Added strict nested fragment validation for allowed fields, attribute-set shape, module lists, complete field paths, and actual types.
- Added `modulesForPlatform` aggregation with explicit `nixos`/`darwin` dispatch and per-recipe common-before-platform ordering.
- Passed the backend platform explicitly from `lib/mkSystem.nix` into `config/recipe-assembly.nix`.
- Migrated all recipe declarations without changing host recipe roots or include relationships.
- Updated the README contract and focused graph tests for common-only, platform-only, mixed, ordering, malformed nested fields, legacy aliases, and unsupported platforms.

## Validation

- `nix-instantiate --parse` passed for all Nix files under `config`, `lib`, and `tests`.
- Focused graph evaluation passed.
- `alejandra --check .` passed.
- `statix check .` passed after replacing a new assignment with `inherit`.
- `deadnix .` continues to report the pre-existing unused `pyf` argument in `config/recipe/overlay/default.nix`.
- `nix flake check --no-build --all-systems --show-trace` passed.
- Explicit derivation-path evaluation passed for all three Darwin hosts and both NixOS hosts.
- The declaration audit reports no `systemModules` or `homeModules` fields under `config/recipe`.

## Follow-up

Consolidating platform-specific recipe entrypoints such as `hm/macos` and `hm/nixos` into the `hm` recipe is intentionally separate from this behavior-neutral schema migration. That follow-up will remove obsolete entrypoints and must be kept as a separate atomic change.

## Naming correction

- Host declarations now use `backend = "darwin"` or `backend = "nixos"`; `os` and `distribution` were removed.
- `host.platform` remains the full Nix system identifier such as `aarch64-darwin` or `aarch64-linux`.
- Assembly and graph dispatch use `backend`/`modulesForBackend` so the selector is not confused with the full Nix platform string.
- The host-field rename and backend terminology were validated with the same formatter, static, graph, flake, and five-host evaluation checks.

## Platform recipe consolidation

- Merged the paired platform implementations into `1password`, `hm`, `nix`, `podman`, `nh`, `ws-cleanup`, and `vm`.
- Inlined the former Home Manager platform module files into `config/recipe/hm/default.nix`.
- Removed obsolete platform entrypoints and updated the macOS/NixOS composition recipes and host roots.
- Kept standalone capabilities and independent composition recipes such as `nixos/gui`, `macAppUtil`, and `macos/personal` unchanged.

Validation after consolidation:

- Nix parsing, Alejandra, Statix, focused graph tests, `nix flake check --no-build --all-systems --show-trace`, and all five host derivation evaluations passed.
- Deadnix still reports only the pre-existing unused `pyf` argument in `config/recipe/overlay/default.nix`.
- No obsolete paired recipe names remain in `config` declarations or host roots.
