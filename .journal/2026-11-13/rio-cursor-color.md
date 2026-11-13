# Set Rio cursor color

## Changes

- Set Rio's `colors.cursor` value to `#ebdbb2` in `config/recipe/rio/default.nix`.
- The cursor now matches the Gruvbox foreground and contrasts with the `#282828` background.

## Validation

- `nix eval` resolved the generated Rio configuration for `beleap-m1air`.
- Nix built the generated Rio TOML file.
- Nix-provided Python parsed the TOML and confirmed `colors.cursor = "#ebdbb2"`.
- Alejandra and Statix passed for the changed Nix file.

## Not run

- I did not build or activate the full Darwin system configuration.
