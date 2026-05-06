# Fix `lib/mkSystem.nix` nix-darwin attribute access regression

- Follow-up for CI failure after input destructuring tidy.
- Failure observed in CI:
  - `error: attribute 'nix-darwin' missing`
  - at `lib/mkSystem.nix` Darwin configuration construction.
- Root cause: hyphenated flake input keys cannot be accessed via dotted syntax as `inputs.nix-darwin`; this does not resolve the intended `"nix-darwin"` attribute.
- Fix: use quoted attribute access `inputs."nix-darwin".lib.darwinSystem`.

## Validation

- Local command attempted for parity with CI:
  - `nix build .#darwinConfigurations.beleap-m1air.system --accept-flake-config --no-link --print-out-paths`
- This environment does not provide `nix` (`nix: command not found`), so build validation remains for CI.
