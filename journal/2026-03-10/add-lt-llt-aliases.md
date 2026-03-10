# Add lT and llT aliases

## Summary
- Added `lT` alias mapped to `ls -t`.
- Added `llT` alias mapped to `ls -lt`.

## Notes
- Aliases were added in `config/recipe/development/default.nix` under `home.shellAliases`, so they apply in the Home Manager profile where existing shell aliases are centrally defined.
