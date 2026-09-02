# Set K9s Gruvbox skin

- Restored declarative `programs.k9s` configuration in `config/recipe/kubernetes/default.nix`.
- Configured K9s to use the `gruvbox` skin, kept `skipLatestRevCheck = true` and `maxConnRetry = 3`, and moved package ownership to `programs.k9s.package = pkgs.unstable.k9s`.
- Replaced the unused Catppuccin skin file with `config/recipe/kubernetes/gruvbox.yaml`, based on K9s's official Gruvbox Dark skin.
- Verified the generated K9s config contains `k9s.ui.skin: gruvbox`, the skin is registered, YAML parses, Alejandra formatting passes, and the `beleap-m1air` Darwin system builds.
- `nix flake check --no-build --show-trace` remains blocked by an unrelated existing Starship evaluation failure: missing `/nix/store/...-starship-1.25.1.drv` while reading the Starship preset.
