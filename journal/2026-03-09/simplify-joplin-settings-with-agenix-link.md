# Simplify Joplin settings secret wiring

## Summary
- Switched Joplin Home Manager config to use `joplin-settings.age` directly.
- Removed activation-time JSON generation logic and token-specific handling.

## Changes
- Updated `config/recipe/joplin/default.nix`:
  - `age.secrets.joplin-settings.file = ./secrets/joplin-settings.age`
  - `home.file.".config/joplin/settings.json".source = config.lib.file.mkOutOfStoreSymlink config.age.secrets."joplin-settings".path`
  - kept `force = true`
- Confirmed `config/recipe/joplin/secrets/secrets.nix` is already set to `"joplin-settings.age"`.

## Validation
- `nix-instantiate --parse config/recipe/joplin/default.nix` passed.

## Follow-up fix
- Fixed infinite recursion from malformed `imports` entry in `config/recipe/joplin/default.nix`.
- Changed:
  - from separate list elements `../../../lib/agenix/hm.nix` and `{ inherit agenix metadata; }`
  - to function import call `(import ../../../lib/agenix/hm.nix { inherit agenix metadata; })`
