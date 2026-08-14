# Add `jws`

- Added the zsh `jws` function to identify the current WezTerm workspace from `WEZTERM_PANE` and `wezterm cli list --format json`.
- `jws` changes into the corresponding try-managed directory at `~/ws/<workspace-name>` and reports clear errors when the pane, workspace, or directory cannot be resolved.

Validation:

- Targeted Alejandra formatting check passed for `config/recipe/zsh/default.nix`.
- `nix flake check` passed; it reported only the existing Home Manager default-change warnings.
