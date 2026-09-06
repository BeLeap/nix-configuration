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
