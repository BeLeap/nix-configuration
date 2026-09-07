# Set up AeroSpace scratchpad for KeePassXC

## Outcome

- Added the pinned `cristianoliveira/aerospace-scratchpad` v0.6.0 flake input.
- Configured AeroSpace to use `pkgs.unstable.aerospace` v0.21.3-Beta.
- Installed `aerospace-scratchpad` in the macOS Home Manager profile.
- Bound `Alt+Shift+K` to toggle the KeePassXC window with the `KeePassXC` app-name pattern.
- Added the scratchpad `hook pull-window` command to the existing workspace-change handler.
- Updated the PIP helper to use the same unstable AeroSpace CLI as the managed service.

## Packaging note

The v0.6.0 upstream Nix expression contains stale source and Go vendor hashes. The Aerospace recipe overrides those hashes locally while keeping the upstream v0.6.0 package definition and lock pin.

## Validation

- Generated AeroSpace TOML contains the KeePassXC binding and absolute scratchpad executable path.
- Generated workspace-change script contains both the PIP handler and scratchpad hook.
- Generated AeroSpace config derivation built successfully.
- `nix build .#darwinConfigurations.beleap-m1air.system --accept-flake-config --no-link --show-trace` passed.
- Alejandra formatting, Statix, and Deadnix checks passed.
- `nix flake check --no-build --all-systems --show-trace` remains blocked by the pre-existing NixOS-only `poke-token-bar` package being unsupported on `aarch64-linux`.

## Follow-up correction

- Replaced the KeePassXC-specific binding with a generic `scratchpad-apps` list.
- Assigned the configured applications to the scratchpad workspace when detected.
- Added a group toggle on `Alt+Shift+S`: if any configured app is visible, hide all configured apps; otherwise show all running configured apps.
- KeePassXC remains the first configured app and can be extended by adding entries to `scratchpad-apps`.
- Rebuilt the affected Darwin system after this correction; the build passed.

## Toggle detection fix

- Root cause: `aerospace list-windows --all --json` emits only its default JSON fields, which omit `app-bundle-id` and `workspace`.
- Updated the toggle to request both fields with `--format '%{app-bundle-id}%{tab}%{workspace}'` while retaining JSON output.
- Confirmed the live AeroSpace output identifies KeePassXC as `org.keepassxc.keepassxc` and reports its current workspace.
- Rebuilt the Darwin configuration successfully and verified the generated toggle script contains the corrected command.
- Alejandra formatting check passed for `config/recipe/aerospace/default.nix`.

## Recipe organization

- Split the Aerospace recipe into purpose-specific files:
  - `default.nix` assembles packages, scripts, keybindings, and settings.
  - `app-assignments.nix` owns scratchpad, floating, and workspace rules.
  - `keybindings.nix` owns workspace and action bindings.
  - `scripts.nix` owns the scratchpad toggle, PiP handler, and workspace hook.
- Kept the generated binding values and 13 window-rule ordering unchanged.
- Replaced repeated executable lookups and shell pipelines with shared helpers and JSON parsing.

## Validation

- Alejandra, Statix, and Deadnix checks passed.
- Darwin configuration build passed.
- Live checks detected KeePassXC as running and returned no PiP window.
- `nix flake check --no-build --all-systems --show-trace` remains blocked by the unrelated NixOS-only `poke-token-bar` package on `aarch64-linux`.
