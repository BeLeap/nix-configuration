# Enhancement 3: Model common and platform-specific recipe fields

## Goal

Represent common configuration once while allowing each recipe to contribute NixOS-, nix-darwin-, and Home Manager-specific differences. Keep one recipe capable of owning the complete cross-platform behavior of a feature.

Estimated implementation time: **3–5 hours**, including declaration migration, graph tests, and all-host evaluation.

## Current problem

The strict recipe contract from Enhancement 1 uses:

```nix
{
  includes = [];
  systemModules = [];
  homeModules = [];
}
```

`systemModules` does not say whether a value is portable across NixOS and nix-darwin or valid for only one evaluator. The repository currently represents many platform differences through separate recipe paths such as `nix/macos`, `nix/nixos`, `hm/macos`, and `hm/nixos`.

Replacing `systemModules` with only `nixos` and `darwin` fields would make platform ownership explicit but duplicate the many modules valid on both platforms. Home Manager also has common and platform-specific behavior, so treating `home` as unconditionally portable would leave the model asymmetric.

## Target declaration contract

Use common fields for the usual case and additive platform fragments for differences:

```nix
_: {
  includes = [];

  system = [];
  home = [];

  nixos = {
    system = [];
    home = [];
  };

  darwin = {
    system = [];
    home = [];
  };
}
```

All fields are optional. Missing lists default to `[]`; missing `nixos` or `darwin` fragments default to `{}` before their nested defaults are applied.

The names intentionally omit a `Modules` suffix. The recipe contract already defines `system`, `home`, `nixos.system`, and related fields as module lists.

## Semantics

For a NixOS configuration, each expanded recipe contributes in this order:

```text
recipe.system
recipe.nixos.system
recipe.home
recipe.nixos.home
```

For a nix-darwin configuration, each expanded recipe contributes:

```text
recipe.system
recipe.darwin.system
recipe.home
recipe.darwin.home
```

Ordering is per recipe, not “all common modules followed by all platform modules.” Preserve the recipe graph’s stable preorder and append each recipe’s selected platform contribution immediately after its common contribution.

The assembly backend must receive its platform explicitly from `mkSystem`. Do not infer platform from arbitrary host metadata and do not use platform to select different recipes automatically. Hosts still select recipe roots explicitly; assembly only chooses which fields of those already-selected recipes apply.

## Examples

### Fully portable recipe

```nix
_: {
  system = [
    ({pkgs, ...}: {
      environment.systemPackages = [pkgs.git];
    })
  ];

  home = [
    ({...}: {
      programs.git.enable = true;
    })
  ];
}
```

### Common behavior with platform differences

```nix
_: {
  home = [commonHomeModule];

  nixos = {
    system = [nixosServiceModule];
    home = [nixosHomeModule];
  };

  darwin = {
    system = [darwinServiceModule];
    home = [darwinHomeModule];
  };
}
```

### One platform only

```nix
_: {
  darwin.system = [darwinOnlyModule];
}
```

A platform-only field is intentionally ignored by the other assembly backend. This supports broader recipes that include platform-specific capabilities without metadata-driven recipe branching. User-facing capability completeness and unsupported-platform assertions remain the responsibility of recipe composition and module assertions.

## Strict validation

Allow only these top-level keys:

- `includes`;
- `system`;
- `home`;
- `nixos`;
- `darwin`.

Allow only `system` and `home` inside `nixos` and `darwin`.

Validate that:

- `includes` is a list of strings;
- every module field is a list of functions;
- `nixos` and `darwin` are attribute sets;
- unknown top-level or nested fields fail with the complete field path;
- malformed values report the recipe name, expected type, and actual type.

Do not normalize single modules or nested lists. Do not silently accept compatibility aliases for `systemModules` or `homeModules` after migration.

## Migration sequence

1. Extend focused graph tests for common-only, platform-only, mixed, malformed nested fields, and ordering cases.
2. Add explicit `nixos` or `darwin` backend selection to assembly without changing existing declarations yet.
3. Change the graph declaration validator and aggregation result to the new schema.
4. Migrate `systemModules` to `system` where the module is valid on both platforms.
5. Migrate platform-specific system modules to `nixos.system` or `darwin.system`.
6. Migrate `homeModules` to `home`, `nixos.home`, or `darwin.home` according to actual compatibility.
7. Compare recipe expansion and evaluated host behavior before consolidating any platform recipe paths.

Keep this migration behavior-neutral. Consolidating recipes such as shared and platform-specific 1Password variants belongs to Enhancement 4 after the field model is validated.

## Migration classification

For every existing module value, ask:

1. Does it evaluate and express the intended policy on both NixOS and nix-darwin? Use `system`.
2. Is it valid only in NixOS? Use `nixos.system`.
3. Is it valid only in nix-darwin? Use `darwin.system`.
4. Is a Home Manager module portable across both host platforms? Use `home`.
5. Does a Home Manager module contain platform-specific programs, paths, or activation behavior? Use `nixos.home` or `darwin.home`.

Do not duplicate a common module into both platform fragments merely because its current callers use separate platform recipes.

## Acceptance criteria

- The strict recipe contract contains `includes`, `system`, `home`, `nixos`, and `darwin` only.
- Common modules are declared once.
- NixOS assembly consumes common plus NixOS contributions and never Darwin contributions.
- nix-darwin assembly consumes common plus Darwin contributions and never NixOS contributions.
- Platform-specific Home Manager contributions follow the same dispatch semantics.
- Per-recipe common-before-platform ordering is covered by focused tests.
- Unknown nested fields and malformed fragments fail explicitly.
- No declaration fields named `systemModules` or `homeModules` remain.
- Recipe roots and include expansion remain unchanged during migration.
- All five hosts retain their pre-migration behavior and evaluate successfully.

## Validation

Run the global checks from [README.md](README.md), plus focused graph and assembly tests.

Search declaration fields after migration:

```bash
rg '\b(systemModules|homeModules)\s*=' config/recipe -g '*.nix'
rg '\b(system|home|nixos|darwin)\s*=' config/recipe -g '*.nix'
```

The first command must have no declaration-field matches. Review the second command manually because module option bodies may contain attributes with the same names.

Add synthetic resolver tests proving the exact output order for both backends. Evaluate all three Darwin hosts and both NixOS hosts; a check of only one backend cannot validate this enhancement.

## Non-goals

- Do not infer recipe selection from platform metadata.
- Do not consolidate platform recipe paths in the schema-migration revision.
- Do not change packages, services, or user policy while moving fields.
- Do not add aliases that allow old and new field names indefinitely.
- Do not require common configuration to be duplicated under `nixos` and `darwin`.
