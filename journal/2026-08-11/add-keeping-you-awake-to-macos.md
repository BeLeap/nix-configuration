# Add KeepingYouAwake to macOS

Added `pkgs.keeping-you-awake` to the shared macOS system packages so every macOS host installs the application.

## Validation

- `git diff --check` passed.
- Alejandra and `nix flake check --no-build` could not run because neither Alejandra nor Nix is installed in the environment.
