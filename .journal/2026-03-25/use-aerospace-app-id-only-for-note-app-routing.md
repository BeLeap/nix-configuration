# Use Aerospace app-id only for note app routing

## Summary
- Removed app-name based Aerospace matching for Joplin and Notion.
- Kept only `app-id` rules to route note apps to workspace 3.

## Why
- App IDs are explicit and reduce unintended matches from broad name-based rules.

## Files changed
- `config/recipe/aerospace/default.nix`
