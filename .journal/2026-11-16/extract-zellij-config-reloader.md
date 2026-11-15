# Extract Zellij config reloader into a public repository

## Changes

- Created [BeLeap/zellij-config-reloader](https://github.com/BeLeap/zellij-config-reloader) as a public repository.
- Moved the Rust plugin, `Cargo.lock`, and WASM build derivation into the new repository.
- Added a Nix flake for `aarch64-darwin`, `aarch64-linux`, and `x86_64-linux`.
- Connected the Zellij recipe to the new flake input through `nixpkgs-unstable`.
- Updated the WASI build toolchain to Rust 1.99.1 because current unstable Nixpkgs no longer provides `rust_1_95`.
- Excluded `x86_64-darwin` because Nixpkgs 26.11 dropped that platform.

## Validation

- The standalone `aarch64-darwin` WASM package build passed.
- Nix evaluated the `aarch64-linux` and `x86_64-linux` package derivations.
- The `beleap-m1air` Darwin system build passed.
- Alejandra and Statix checks passed for the changed Nix files.
- Zellij 0.46.0 accepted the generated config with `setup --check`.
- `file` identified the generated artifact as a WebAssembly module.

## Limitation

- I did not apply the system configuration or restart the active Zellij server.

## Follow-up: preserve the license and record final checks

- Copied the existing MIT `LICENSE` into the public repository.
- Pushed revision `343a8a5bd1695994f5202cb2b5b105f566c409a1` and updated the main flake lock.
- The final Darwin rebuild started rebuilding the unrelated `wts` recipe and GNU sed dependency. I stopped that rebuild.
- The earlier Darwin system build passed after the plugin integration.
- The generated Zellij config passed `setup --check` again with Zellij 0.46.0.
- The main working copy also contains changes to `config/recipe/overlay/pkgs/beleap-utils/default.nix` and `config/recipe/overlay/pkgs/beleap-utils/scripts/wts`. I left both files untouched.
