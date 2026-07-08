# Enable opencode LSP

## Change
- Enabled opencode's built-in LSP support by setting `programs.opencode.settings.lsp = true` in `config/recipe/opencode/default.nix`.

## Notes
- OpenCode documentation says omitting `lsp` leaves LSP disabled, while `lsp = true` enables all built-in LSP servers.

## Validation
- Attempted `nix-instantiate --parse config/recipe/opencode/default.nix`, but validation could not run because `nix-instantiate` is not installed in this environment.
