# Joplin api.token from agenix

## Summary
- Updated `config/recipe/joplin/default.nix` to source `api.token` from the agenix secret `joplin-api-token` at activation time.
- Avoided `builtins.readFile` for secrets to prevent cleartext leakage into the Nix store.

## Changes
- Fixed module option typo: `import` -> `imports`.
- Extended module args to include `config` and `lib`.
- Added `home.activation.joplinSettings` with `lib.hm.dag.entryAfter ["writeBoundary"]`:
  - Validates secret file existence.
  - Reads token from `${config.age.secrets."joplin-api-token".path}`.
  - Generates `~/.config/joplin/settings.json` using `jq` with proper JSON escaping.
- Removed static `home.file` management for `settings.json` to avoid symlink overwrite conflicts.

## Validation
- Ran `nix-instantiate --parse config/recipe/joplin/default.nix` successfully.
