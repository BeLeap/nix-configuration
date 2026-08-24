# Separate the Homebrew recipe

- Moved common Homebrew enablement, activation cleanup behavior, formulae, and casks out of the `macos` recipe into a dedicated `homebrew` recipe.
- Added the `homebrew` recipe explicitly to every nix-darwin host so all current macOS systems retain the same Homebrew configuration.
- Kept the recipe Darwin-only, allowing its platform boundary and host selection to remain explicit.
