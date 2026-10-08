# nix-configuration

Personal Nix flake for macOS (`nix-darwin`) and NixOS hosts.

## For Coding Agents

Use this section to make changes that are small and easy to review.

### Scope and Outputs

- Flake entry point: `flake.nix`
- Generated outputs:
  - `darwinConfigurations.<host>.system`
  - `nixosConfigurations.<host>.*`
- Host inventory: `config/hosts.nix`
- Default recipe set: `config/recipe/default/default.nix`
- Recipe assembly: `config/recipe-assembly.nix`

### Important Paths

- Feature recipes: `config/recipe/`
- Shared Home Manager setup: `config/recipe/hm/`
- macOS recipes: `config/recipe/macos/`
- NixOS recipes: `config/recipe/nixos/`
- Shared default recipe list: `config/recipe/default/`
- Per-host system assembly: `lib/mkSystem.nix`
- Recipe graph resolver: `lib/recipe-graph.nix`
- Flake output builder: `lib/build-configs.nix`
- VM build helper: `bin/run-vm`

### Recipe Graph Contract

Recipe entrypoints return attribute sets. Each set can contain only these optional
fields: `includes`, `system`, `home`, `nixos`, and `darwin`.

- `includes` lists recipe names.
- `system` and `home` list common modules. Each module must be a function.
- `nixos` and `darwin` can each contain `system` and `home` lists for platform-specific modules.

The resolver processes roots in compatibility order. For each root, it processes
the recipe before its included recipes. It keeps the declared include order. If a
recipe occurs more than once, it uses the first occurrence.

Assembly uses the backend that the host specifies. For each recipe, assembly
applies common modules before backend-specific modules.

Set module precedence with explicit Nix module priorities. Do not use recipe
graph order to set module precedence.

### Common Commands

- Check formatting:
  - `nix run nixpkgs#alejandra -- --check .`
- Check for unused Nix code:
  - `nix run nixpkgs#deadnix -- .`
- Check Nix style:
  - `nix run nixpkgs#statix -- check .`
- List Darwin hosts:
  - `nix eval --json .#darwinConfigurations --apply builtins.attrNames`
- List NixOS hosts:
  - `nix eval --json .#nixosConfigurations --apply builtins.attrNames`
- Build a Darwin host without linking the result:
  - `nix build ".#darwinConfigurations.<darwin-host>.system" --accept-flake-config --no-link`
- Build a NixOS host VM without linking the result:
  - `nix build ".#nixosConfigurations.<nixos-host>.config.system.build.vm" --accept-flake-config --no-link`

### Local Apply Commands

- Apply the first macOS configuration:
  - `sudo nix --extra-experimental-features "nix-command flakes" run "nix-darwin/master#darwin-rebuild" -- switch --flake ".#<darwin-host>"`
- Apply a macOS configuration after setup:
  - `nh darwin switch`

### Change Workflow (Agent-Friendly)

1. Keep each change small. Put recipe changes in the relevant recipe.
2. For behavior that needs a new recipe, add `config/recipe/<name>/default.nix`.
3. Add shared recipes to `config/recipe/default/default.nix`, a nested recipe
   list, or a host recipe list in `config/hosts.nix`.
4. Run formatting and static checks before you submit a change.
5. Build at least one affected host output. This checks for evaluation and build failures.

## Credits

The instructions in [`files/AGENTS.md`](files/AGENTS.md) use principles from
the [`CLAUDE.md` guide](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md).
