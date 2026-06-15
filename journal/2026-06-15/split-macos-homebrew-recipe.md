# Split macOS Homebrew recipe

- Moved Homebrew enablement and common formulas/casks out of the base `macos` recipe.
- Added explicit `macos/homebrew` recipe.
- Updated current macOS hosts to include the Homebrew recipes explicitly.
- Kept personal Homebrew casks/MAS apps in `macos/personal` because there is no current personal airgap host.
- This preserves a future airgap macOS host path: include `macos` but omit `macos/homebrew` and any other Homebrew-backed recipes.
