# Add HomeRow recipe

- Added `config/recipe/homerow/default.nix` as a separate Darwin Home Manager recipe.
- Installed the Nixpkgs package through `pkgs.unstable.homerow`; the pinned stable package set does not expose it, while the existing unstable input provides HomeRow 1.5.3.
- Enabled the recipe for `beleap-m1air` and the repository's existing M3 Pro host `csjang-m3pro`; no `beleap-m3pro` host exists in the current inventory.

## Validation

- Alejandra formatting check passed.
- `statix check .` passed.
- `deadnix .` passed.
- Darwin derivation evaluation passed for `beleap-m1air` and `csjang-m3pro`.
- Darwin builds passed for both hosts.
- `nix flake check --show-trace` remains blocked by the existing `ax-cli` package being unsupported on `aarch64-linux` while evaluating a NixOS output; this is unrelated to the HomeRow recipe.
