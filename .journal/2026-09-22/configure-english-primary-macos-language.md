## Outcome

- Added `system.defaults.CustomUserPreferences.NSGlobalDomain` to `config/recipe/macos/default.nix`.
- Configured macOS language order as English (`en-US`) followed by Korean (`ko-KR`).
- Kept the locale as `en_KR`, so the interface language is English while regional formatting remains Korea-based.

## Validation

- `nix-instantiate --parse config/recipe/macos/default.nix` passed.
- `nix build '.#darwinConfigurations.beleap-m1air.system' --accept-flake-config --no-link` passed.
- The installed `jj diff` does not support `--check`; the focused diff was inspected with `jj diff --summary` and `jj diff --git` instead.

## Activation

- The change is declarative only. Apply it on macOS with `darwin-rebuild switch --flake '.#beleap-m1air'`.
