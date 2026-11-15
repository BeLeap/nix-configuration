# Return to WezTerm with native workspaces

## Changes

- Restored `config/recipe/wezterm/` from the pre-Rio WezTerm configuration.
- WezTerm starts in the `sp` workspace and manages panes and workspaces natively.
- `wts` selects directories under `~/ws` and creates date-prefixed directories for new names.
- `wts` switches to an existing WezTerm workspace or creates one with the selected directory as its working directory.
- `wts` opens a new WezTerm window when the command runs outside WezTerm.
- Restored `wzs` and `wzsf` for direct WezTerm workspace switching and selection.
- Restored the WezTerm workspace lookup in `jws` and Pi notification titles.
- Removed the Rio and Zellij recipes, the Zellij-only `wts` dependency, and the Zellij config-reloader flake input.
- Updated the Dock, Aerospace, Hyprland, and Starship references for WezTerm.

## Validation

- Alejandra, Statix, ShellCheck, `luac -p`, and `bash -n` passed.
- Mocked `wts` tests passed for existing workspaces, new workspaces, outside-WezTerm launch, and fzf cancellation.
- Darwin system evaluation passed for `beleap-m1air`.
- The `beleap-utils` build passed and contains executable `wts`, `wzs`, and `wzsf` commands.
- Nix evaluated the Linux `wezterm-upstream` package derivation.
- `make check` passed the flake checks, then failed during NixOS evaluation because `utm-5.0.8` does not support `aarch64-linux`.
- The VM host does not include `nixos.gui`, so the Hyprland binding did not run in that system evaluation.
- I did not apply the Darwin system configuration.
