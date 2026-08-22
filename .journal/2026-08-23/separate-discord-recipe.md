# Separate Discord recipe

- Extracted the Discord Dock entry and Home Manager settings into `config/recipe/discord/default.nix`.
- Included the recipe from `config/recipe/macos/personal/default.nix`, so personal macOS hosts manage Discord while the personal NixOS profile remains unchanged.
- Discord is still supplied by `pkgs.unstable.discord`; Home Manager manages only `Library/Application Support/discord/settings.json` with `SKIP_HOST_UPDATE = true` via `package = null`.

## Validation

- Alejandra check passed for both changed Nix files.
- `darwin-rebuild build --flake .#beleap-m1air` passed.
- Generated settings output contains `SKIP_HOST_UPDATE: true`.
