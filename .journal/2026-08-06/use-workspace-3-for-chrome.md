# Use Aerospace workspace 3 for Chrome

## Summary

- Changed the Aerospace Chrome window rule to move new Chrome windows to workspace 3 instead of workspace 2.

## Files changed

- `config/recipe/aerospace/default.nix`

## Validation

- Reviewed the focused diff and verified that only Chrome's target workspace changed.
- Could not run the formatter or flake checks because `nix` is not installed in the environment.
