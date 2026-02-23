# nix-configuration

Personal Nix flake for macOS (`nix-darwin`) and NixOS hosts.

## For Coding Agents

This section is optimized for code agents making safe, reviewable changes.

### Scope and Outputs

- Flake entrypoint: `flake.nix`
- Generated outputs:
  - `darwinConfigurations.<host>.system`
  - `nixosConfigurations.<host>.*`
- Host inventory: `config/hosts.nix`
- Base recipes: `config/recipes.nix`
- Recipe loader: `config/default.nix`

### Important Paths

- `config/recipe/`: feature modules ("recipes")
- `config/recipe/hm/`: shared Home Manager wiring
- `config/recipe/macos/`: host-specific macOS recipes
- `config/recipe/nixos/`: host-specific NixOS recipes
- `lib/mkSystem.nix`: per-host system assembly
- `lib/build-configs.nix`: folds host metadata into flake outputs
- `bin/run-vm`: helper for VM builds

### Common Commands

- Format check:
  - `nix run nixpkgs#alejandra -- --check .`
- Static checks:
  - `nix run nixpkgs#deadnix -- .`
  - `nix run nixpkgs#statix -- check .`
- List Darwin hosts:
  - `nix eval --json .#darwinConfigurations --apply builtins.attrNames`
- List NixOS hosts:
  - `nix eval --json .#nixosConfigurations --apply builtins.attrNames`
- Build Darwin host (generic):
  - `nix build ".#darwinConfigurations.<darwin-host>.system" --accept-flake-config --no-link`
- Build NixOS host VM (generic):
  - `nix build ".#nixosConfigurations.<nixos-host>.config.system.build.vm" --accept-flake-config --no-link`

### Local Apply Commands

- Initial bootstrap (macOS):
  - `sudo nix --extra-experimental-features "nix-command flakes" run "nix-darwin/master#darwin-rebuild" -- switch --flake ".#<darwin-host>"`
- Regular switch (macOS):
  - `nh darwin switch`

### Change Workflow (Agent-Friendly)

1. Keep edits small and recipe-scoped where possible.
2. If adding behavior, prefer a new file under `config/recipe/<name>/default.nix`.
3. Wire new recipes through `config/recipes.nix` (global) or a host recipe list in `config/hosts.nix`.
4. Run format + static checks before proposing completion.
5. Build at least one affected host output to catch evaluation/build regressions.

### Known Caveats

- CI currently builds only macOS host outputs in `.github/workflows/build.yml`.
- `config/default.nix` recipe import is one level deep (`recursiveImport` is not fully recursive).
- Keep branch naming assumptions out of scripts unless required by target repo.
