# Merge personal Homebrew additions

- Removed the separate `macos/homebrew/personal` recipe.
- Moved personal-only Homebrew casks and MAS apps into `macos/personal`.
- Kept common Homebrew enablement in `macos/homebrew` so airgap macOS hosts can still omit Homebrew entirely.
