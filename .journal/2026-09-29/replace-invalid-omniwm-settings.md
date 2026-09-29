# Replace invalid OmniWM settings

## Outcome

- Replaced the partial TOML with a complete OmniWM schema-v3 configuration for the installed v0.7.1 release.
- Preserved the intended settings: IPC enabled, workspace bar below the menu bar, and clipboard history enabled.
- Restored the release defaults for required hotkeys, workspaces, app rules, and other settings; removed legacy `monitorRoutingOverrides`.

## Validation

- Parsed the TOML and checked required v3 sections, 188 unique hotkey IDs, nine default workspaces, and 13 default app rules.
- `nix eval` resolved the Home Manager source to the new settings file in the store.

## Pending

- The running OmniWM process still uses the old Home Manager generation. Run `nh darwin switch`, restart OmniWM, then verify with `omniwmctl ping`.
