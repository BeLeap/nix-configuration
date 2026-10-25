# Disable Pi Auto Model by default

- Updated `config/recipe/pi/default.nix` to set `autoModel.enabled = false` in the generated Pi settings.
- Kept `npm:pi-auto-model` in the package list. Users can enable routing in a session with `/auto-model on`.
- Validation: `nix-instantiate --parse config/recipe/pi/default.nix` passed.
