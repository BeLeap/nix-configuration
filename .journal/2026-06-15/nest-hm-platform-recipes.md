# Nest Home Manager platform recipes

- Replaced top-level `hm-macos` and `hm-nixos` recipes with nested `hm/macos` and `hm/nixos` recipes.
- Moved the platform-specific Home Manager user modules to `hm/macos/module.nix` and `hm/nixos/module.nix`.
- Updated macOS and NixOS recipes to reference the nested recipe names.
