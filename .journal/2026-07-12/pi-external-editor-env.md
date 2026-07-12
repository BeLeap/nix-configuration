# Pi external editor via environment

Removed the explicit `externalEditor = "hx"` setting from `config/recipe/pi/default.nix`. Pi will use the existing `$VISUAL`/`$EDITOR` environment configuration, avoiding duplication while retaining declarative global editor management.

Verification: `alejandra --check config/recipe/pi/default.nix` passed.
