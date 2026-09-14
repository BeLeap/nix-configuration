# Apply nixpkgs PR #562806 as a Joplin overlay

## Outcome

- Added `nixpkgs-joplin` to `flake.nix`, sourcing `github:NixOS/nixpkgs/pull/562806/head`.
- Locked it in `flake.lock` at `29d2812b7e28ca93dd829624d85fc13805d73cf9`.
- Updated the existing overlay recipe to import that package set with the current host platform/config and expose only `joplin-desktop`.
- The overlay resolves Joplin 3.7.18 without replacing the main stable or Darwin nixpkgs inputs.

## Validation

- Joplin 3.7.18 and the PR package position resolved on all three Darwin hosts.
- Joplin 3.7.18 resolved for both NixOS package sets.
- Standalone aarch64-Darwin Joplin package build passed.
- Full `beleap-m1air` Darwin system build passed.
- Repository-wide Alejandra formatting passed.
- Focused Deadnix and Statix checks passed for the changed files.

## Limitation

- `nix flake check --no-build --show-trace` remains blocked by the pre-existing Darwin-only `ax-cli` package while evaluating the aarch64-linux VM configuration; this is unrelated to the Joplin overlay.
