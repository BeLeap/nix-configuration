# Use the Darwin-specific Nixpkgs branch

## Outcome

- Added the `nixpkgs-darwin` flake input at `github:NixOS/nixpkgs/nixpkgs-26.05-darwin`.
- Changed `nix-darwin.inputs.nixpkgs.follows` from `nixpkgs` to `nixpkgs-darwin`.
- Locked the new input at revision `c19db427a1fdfc7591c0b0baeb4665dcef2c61da`.

## Validation

- `nix flake lock` passed.
- Flake metadata confirms nix-darwin follows `nixpkgs-darwin`, whose locked branch is `nixpkgs-26.05-darwin`.
- Alejandra style check passed for `flake.nix`.
- Darwin system derivation evaluation passed for `beleap-m1air`, `beleap-macmini`, and `csjang-m3pro`.
- `nix flake check --no-build --show-trace` remains blocked by the existing invalid cached `starship-1.25.1.drv` while evaluating the NixOS configuration.

## 2026-09-20 — Align Darwin Home Manager with Darwin Nixpkgs

## Outcome

- Added a separate `home-manager-darwin` input following `nixpkgs-darwin`.
- Kept the existing `home-manager` input following plain `nixpkgs` for NixOS.
- Updated the Darwin Home Manager recipe to import `home-manager-darwin.darwinModules.home-manager`.

## Validation

- `nix flake lock` passed and recorded the Darwin Home Manager input.
- Alejandra and Statix checks passed for the changed Nix files.
- Recipe-graph validation passed.
- Darwin system derivations evaluated for `beleap-m1air`, `beleap-macmini`, and `csjang-m3pro`.
- `nix build .#darwinConfigurations.beleap-m1air.system --no-link` passed.
- The NixOS Home Manager option check passed; full NixOS toplevel evaluation remains blocked by the existing Darwin-only `ax-cli` package on `aarch64-linux`.
