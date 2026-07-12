# Show Starship shell icon

- Enabled Starship's `shell` module in `config/recipe/starship/default.nix`.
- Configured Bash, Zsh, and unknown-shell indicators to render the terminal icon `` in the bracketed-segments style.
- Alejandra formatting passed.
- `nix flake check --no-build` could not run in the agent sandbox because access to the Nix daemon socket was denied (`Operation not permitted`).
