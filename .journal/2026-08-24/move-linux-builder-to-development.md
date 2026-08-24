# Move Linux builder to development

## Summary

- Extracted the macOS Linux builder settings from the shared `nix` recipe into a
  dedicated `linux-builder` recipe.
- Included `linux-builder` from `development`, keeping cross-platform builder
  concerns close to the workflows that need them.
- Kept the recipe Darwin-only so Linux development hosts do not receive
  unsupported `nix.linux-builder` options.

## Verification

- `git diff --check` passed.
- Nix evaluation and repository format/static checks were not available because
  the environment does not have `nix`, `alejandra`, `deadnix`, or `statix` on
  `PATH`.
