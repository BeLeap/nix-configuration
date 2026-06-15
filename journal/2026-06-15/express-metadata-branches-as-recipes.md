# Express metadata branches as recipes

- Analyzed remaining metadata-driven branches in recipes and moved host/OS/kind selection into explicit recipe lists where practical.
- Split Home Manager wiring into `hm/macos` and `hm/nixos` recipes.
- Split OS-specific implementations for `1password`, `nix`, `nh`, `podman`, and `ws-cleanup`.
- Moved macOS personal/work Homebrew and Dock additions into `macos/personal` and `macos/work`.
- Moved NixOS GUI composition under `nixos/gui` and removed the old metadata-gated `gui` recipe.
- Removed redundant metadata guards from `kdeconnect-mac`, `macAppUtil`, and `nixos/vm` because those recipes are now selected explicitly.
- Changed agenix Home Manager identity path calculation to derive from `config.home.homeDirectory` instead of branching on metadata OS.
- Left `lib/mkSystem.nix` distribution branching in place because it determines flake output shape (`nixosConfigurations` vs `darwinConfigurations`), not recipe behavior.

Verification:
- `alejandra lib/agenix/hm.nix lib/agenix/common.nix config/recipe`
- `nix flake check --show-trace`
