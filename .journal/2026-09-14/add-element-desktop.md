# Add Element Desktop to personal macOS devices

- Added `pkgs.element-desktop` to the Darwin Home Manager package list in `config/recipe/personal/default.nix`.
- The personal recipe is selected by `beleap-m1air` and `beleap-macmini`, so both personal Macs receive the Element Matrix client through the existing macOS app integration.
- Kept the package in the Darwin-only section because the personal NixOS target is a headless VM without a desktop session.

## Validation

- Alejandra check passed.
- Statix check passed.
- `nix eval` confirmed `element-desktop` is present in the `beleap-m1air` Home Manager package list.
- `nix build .#darwinConfigurations.beleap-m1air.system --accept-flake-config --no-link` passed.
- `nix flake check --show-trace --no-build` remains blocked by the pre-existing Darwin-only `ax-cli` package being evaluated for `aarch64-linux`.
