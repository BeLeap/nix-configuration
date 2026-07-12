# Revert lT and llT aliases to development recipe

## Summary
- Removed `lT` and `llT` from `config/recipe/lsd/default.nix`.
- Restored `lT = "ls -t"` and `llT = "ls -lt"` in `config/recipe/development/default.nix` under `home.shellAliases`.

## Why
- These aliases are useful even when `lsd` is not enabled, so they belong in the broader development shell alias set.
