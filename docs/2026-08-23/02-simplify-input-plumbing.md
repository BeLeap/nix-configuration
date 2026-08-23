# Enhancement 2: Simplify input and host plumbing

## Goal

Make system assembly receive the real flake inputs and host specification explicitly. Remove `callPackage` as global dependency injection for recipe declarations.

Estimated implementation time: **2–4 hours**.

## Current problem

`lib/mkSystem.nix` aliases its complete function argument set as `inputs` and enumerates every flake input in the function pattern. Consequences:

- adding an input requires editing `flake.nix`, `lib/mkSystem.nix`, and sometimes a recipe;
- the name `inputs` includes non-input values such as `lib`, `metadata`, and `recipes`;
- recipe dependencies are hidden behind `lib.callPackageWith` argument matching;
- global names can collide;
- `deadnix` reports most of the enumerated input bindings as unused;
- `metadata` is passed through both system and Home Manager module systems under a vague name.

## Target assembly interface

Pass dependencies directly from `flake.nix`:

```nix
buildConfigs = import ./lib/build-configs.nix {
  inherit inputs;
  lib = inputs.nixpkgs.lib;
};
```

Prefer a curried or explicit constructor:

```nix
mkSystem = import ./mkSystem.nix {inherit inputs lib;};
system = mkSystem {host = metadata;};
```

Inside `mkSystem`, use:

```nix
specialArgs = {inherit inputs host;};
```

Use the same names in Home Manager only where needed:

```nix
home-manager.extraSpecialArgs = {inherit inputs host;};
```

`inputs` must be the actual flake input attribute set. `host` must be the normalized immutable host specification currently produced by `lib/metadata.nix`.

## Dependency rules

- Recipe declarations that need an external flake input must reference it explicitly as `inputs.<name>`.
- Ordinary Nix modules should prefer `pkgs`, `lib`, and `config` over reaching into `inputs`.
- Keep `host` for assembly facts: host name, platform, distribution, username, and email.
- Feature configuration belongs in typed module options, not additional fields added to `host`.
- Values required to calculate `imports` may use `specialArgs`; ordinary configurable values should use module options.

These rules align with the NixOS module distinction between static import arguments and evaluated configuration.

## Implementation steps

1. Change `flake.nix` and `lib/build-configs.nix` to pass the real `inputs` set explicitly.
2. Replace the large `lib/mkSystem.nix` argument pattern with `{inputs, lib}` plus a host argument.
3. Rename module-level `metadata` references to `host` in system and Home Manager modules.
4. Replace recipe-constructor arguments such as `{try}`, `{agenix}`, or `{mac-app-util}` with `{inputs, ...}` and qualified references.
5. Remove `callPackageWith` from recipe loading and import declarations with an explicit context.

Search before editing:

```bash
rg '\bmetadata\b|callPackage|callPackageWith' flake.nix lib config -g '*.nix'
rg '^\s*[a-zA-Z0-9_-]+,' config/recipe -g 'default.nix'
```

The second search is only an inventory aid; distinguish recipe constructor arguments from ordinary module arguments.

## Error handling

Do not retain both `metadata` and `host` as an undocumented compatibility layer. Perform a complete atomic rename, or introduce a clearly documented, immediately removed migration revision if review size requires splitting.

A missing input should fail at the recipe that references `inputs.<name>`. Do not use `or null` unless absence is a supported feature with a typed option and explicit behavior.

## Acceptance criteria

- `lib/mkSystem.nix` does not enumerate flake input names.
- Adding a new flake input requires no assembly-plumbing edit.
- `inputs` always means the actual flake input set.
- Assembly and modules consistently use `host`, not `metadata`.
- Recipe loading no longer relies on `callPackageWith` argument discovery.
- `deadnix` reports no unused declarations in `lib/mkSystem.nix`.
- All five host configurations evaluate successfully.

## Validation

Run the global checks from [README.md](README.md). Also verify that every host still resolves the same platform and username:

```bash
nix eval --json .#darwinConfigurations --apply builtins.attrNames
nix eval --json .#nixosConfigurations --apply builtins.attrNames
```

Inspect a focused `jj diff` to ensure the change is dependency plumbing only. Package lists, services, launch agents, and user settings must remain unchanged.

## Non-goals

- Do not redesign the host inventory format.
- Do not move files into new layers yet.
- Do not make platform capability recipes select their common halves; that belongs to Enhancement 4.
- Do not add feature-specific values to `host`.
