# Pin note apps to Aerospace workspace 3

## Summary
- Added Aerospace window-detection rules to move Joplin and Notion to workspace 3.
- Added both bundle-id and app-name matching for each app to improve matching reliability.

## Files changed
- `config/recipe/aerospace/default.nix`

## Validation
- Reviewed generated Aerospace rule ordering so app-specific rules run before the catch-all workspace 9 rule.
