# Move lT and llT aliases to lsd recipe

## Summary
- Removed `lT` and `llT` aliases from `config/recipe/development/default.nix`.
- Added `lT = "ls -t"` and `llT = "ls -lt"` to `config/recipe/lsd/default.nix` via `home.shellAliases`.

## Why
- Keep aliases tied to `lsd` in the `lsd` recipe rather than the broader development recipe, improving cohesion.
