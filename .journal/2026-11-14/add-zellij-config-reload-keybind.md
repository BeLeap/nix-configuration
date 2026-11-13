# Add Zellij config reload keybind

## Changes

- Added a headless WASM plugin that calls `reload_config_file()` when it receives a keybind pipe message.
- Granted the plugin alias the `Reconfigure` permission.
- Bound `Ctrl-a`, then `r`, to send the reload message.
- Moved the existing `MovePane` action from `r` to `m`.
- Built the plugin with `zellij-tile` 0.46.0, which exports `reload_config_file()`.
- Used the matching Rust 1.95.0 bootstrap compiler and WASI standard library.

## Validation

- Nix built the generated Zellij config and the WASM plugin.
- Zellij 0.46.0 `setup --check` accepted the generated config.
- `file` identified the plugin artifact as a WebAssembly module.
- The Darwin system configuration evaluated successfully.
- Alejandra and rustfmt checks passed.

## Compatibility notes

- `zellij-tile` 0.45.1 does not export `reload_config_file()`.
- The source-built Nix Rust compiler rejected the upstream WASI standard-library metadata. The matching bootstrap compiler fixed that mismatch.

## Follow-up: extract the plugin build and diagnose the runtime version mismatch

- Moved the Rust/WASI toolchain and plugin derivation to `config/recipe/zellij/reload-config.nix`. The Zellij recipe now imports that derivation.
- The generated config points to the plugin built with `zellij-tile` 0.46.0.
- The active `sp` server process uses Zellij 0.45.1. The current CLI reports Zellij 0.46.0.
- This host/plugin version mismatch is the likely cause of the plugin load error. I did not restart `sp` because that could terminate active shell work.
- Alejandra passed for both Zellij Nix files. Darwin system evaluation and build passed.
- Zellij 0.46.0 `setup --check` accepted the generated config. `file` identified the plugin artifact as WebAssembly.

## Follow-up: align Rio's server version with the plugin

- Rio's generated config used the stable `pkgs.zellij` package, which resolved to Zellij 0.45.1. The plugin uses `zellij-tile` 0.46.0.
- Changed Rio to launch `pkgs.unstable.zellij`, matching the plugin host version.
- The generated Rio config now runs Zellij 0.46.0. The Darwin system build and Alejandra checks passed.
- The active `sp` process still runs Zellij 0.45.1. I did not restart it because that could terminate active shell work.
