# Replace Joplin with Obsidian

- Added `config/recipe/obsidian/default.nix` with Darwin Home Manager settings and a Dock entry.
- Moved the `Sync/Personal` vault configuration from `config/recipe/beleap-m1air/default.nix` into the Obsidian recipe.
- Replaced the `joplin` include with `obsidian` in `config/recipe/personal/default.nix`.
- Replaced Joplin's AeroSpace workspace assignment with Obsidian's `md.obsidian` identifier on workspace `3`.
- Removed `config/recipe/joplin/`, including its plugins, encrypted settings, and vendored CLI skill.
- Removed the Joplin Firefox clipper. Left local Joplin data untouched. No system activation ran.

## Validation

- `nix build --no-link .#darwinConfigurations.beleap-m1air.system`: passed.
- `nix eval --raw .#darwinConfigurations.beleap-macmini.system.drvPath`: passed.
- Alejandra formatting and `nix-instantiate --parse` checks passed for all changed Nix files.
- The Obsidian vault target evaluated to `Sync/Personal`. The app bundle identifier evaluated to `md.obsidian`.
- No Joplin references remain in `config`, `flake.nix`, or `flake.lock`.
- NixOS personal-host evaluation remains blocked by the existing `utm-5.0.8` package, which is unsupported on `aarch64-linux`.
