# Make VirtualBoxVM floating in Aerospace

## Summary
- Added an Aerospace `on-window-detected` rule for `org.virtualbox.app.VirtualBoxVM`.
- Configured the rule to run `layout floating` for VirtualBox VM windows.

## Why
- Virtual machine windows are easier to manage in floating mode than tiled mode.

## Files changed
- `config/recipe/aerospace/default.nix`
