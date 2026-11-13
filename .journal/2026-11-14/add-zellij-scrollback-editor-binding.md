# Add Zellij scrollback editor binding

## Changes

- Bound `e` in Scroll mode to `EditScrollback`.
- Return to Locked mode after the editor closes.
- Zellij resolved the default editor to `nvim`.

## Validation

- `zellij --config "$PWD/config/recipe/zellij/config.kdl" setup --check` passed with Zellij 0.45.1.

## Follow-up: Check the active editor environment

- The `sp` Zellij server and its Rio-launched `zellij attach --create sp` process had neither `EDITOR` nor `VISUAL` in their environments.
- The interactive shell had `EDITOR=nvim` and `VISUAL=nvim`; `setup --check` reported `nvim` there.
- With both variables unset, `setup --check` reported `Not set, checked $EDITOR and $VISUAL`.
- The Zellij config still has no `scrollback_editor` option. The `e` binding still invokes `EditScrollback`.
- The active `sp` server runs Zellij 0.45.1. The shell's `zellij` command reports 0.46.0.

## Follow-up: Trace and pin the scrollback editor

- `development/default.nix` sets `EDITOR=nvim` through `home.sessionVariables`. macOS LaunchAgent had neither `EDITOR` nor `VISUAL`, and the Rio and Zellij `sp` processes inherited neither variable.
- Rio launches Zellij directly from its GUI app config. That launch does not inherit the interactive shell's `home.sessionVariables`.
- Added `scrollback_editor` to `config/recipe/zellij/config.kdl`. `config/recipe/zellij/default.nix` resolves it to the Nixvim wrapper's absolute executable path.
- Zellij 0.45.1 accepted a temporary KDL config with the Nixvim path substituted and `EDITOR` and `VISUAL` unset. Its default-config dump documents `scrollback_editor` with default `$EDITOR` or `$VISUAL`.
- Alejandra passed for `config/recipe/zellij/default.nix`.
- The `beleap-m1air` system build failed in the existing `zellij-config-reloader` Rust plugin. The compiler reported missing `meta_sized` lang items. The build did not reach system activation.

## Final validation

- A later `nix build ".#darwinConfigurations.beleap-m1air.system" --accept-flake-config --no-link` passed with the current reload-plugin recipe.
- The built Zellij config resolves `scrollback_editor` to `/nix/store/addpws2cwpi8mf3mgkpa9q8niygypxg4-nixvim/bin/nvim`.
- Zellij 0.45.1 reported the built config as well-defined with `EDITOR` and `VISUAL` unset.
- System activation was not run. The working tree contains other pending configuration changes.
