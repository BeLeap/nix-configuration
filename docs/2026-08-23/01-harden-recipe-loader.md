# Enhancement 1: Harden the recipe loader

## Goal

Keep named recipe composition, but make `config/recipe-assembly.nix` a strict and testable graph resolver rather than a permissive recursive flattener.

Estimated implementation time: **3–5 hours**, including migration of existing declarations and focused graph tests.

## Current problem

`config/recipe-assembly.nix` currently:

- treats missing `recipes`, `base`, and `hm` fields as empty;
- ignores unknown fields, so a typo can silently remove configuration;
- accepts either a module or nested lists because `lib.flatten` normalizes both;
- recursively expands includes without cycle detection;
- does not deduplicate shared transitive dependencies;
- reports raw import/evaluation failures rather than recipe-specific errors;
- places a recipe before its included recipes, but does not document this ordering contract.

The five current hosts do not contain cycles or duplicate expansions. This enhancement prevents future graph changes from creating hard-to-debug behavior.

## Target declaration contract

Every selectable recipe must return exactly this shape:

```nix
{
  includes = ["other-recipe"];
  systemModules = [(_: {})];
  homeModules = [(_: {})];
}
```

All three fields are optional, but when present they must be lists:

- `includes`: list of recipe-name strings;
- `systemModules`: list of function-valued NixOS or nix-darwin modules;
- `homeModules`: list of function-valued Home Manager modules.

Reject every unknown top-level field. Normalize neither a single module nor an arbitrarily nested list. A malformed declaration must fail with the recipe name, offending field, expected shape, and actual type.

## Implementation boundaries

### Resolver

Extract pure graph work from system assembly, for example into `lib/recipe-graph.nix`. It should accept:

- root recipe names;
- a function that resolves a name to a declaration;
- no NixOS, nix-darwin, or Home Manager configuration state.

Return an ordered list of unique recipe declarations or an explicit structure containing ordered recipe names plus aggregated system and home modules.

### Ordering

Preserve current behavior during this enhancement:

1. root recipe order follows the host declaration;
2. a recipe appears before its includes;
3. include order follows the declaration;
4. the first occurrence wins during deduplication.

Document this as compatibility behavior. Module precedence should ultimately use `lib.mkBefore`, `lib.mkAfter`, `lib.mkDefault`, or `lib.mkForce`, not accidental graph order.

### Errors

Provide explicit failures for:

- invalid recipe names before constructing a path, including empty names, absolute paths, empty segments, and `.` or `..` segments;
- unknown root or included recipe;
- missing recipe entrypoint;
- dependency cycle, including the full path such as `a -> b -> c -> a`;
- unknown declaration key;
- non-list declaration fields;
- non-string values in `includes`.

Do not catch an error and continue with an empty recipe.

### Home Manager aggregation

Aggregate Home Manager modules once rather than generating one wrapper module per recipe. The resulting system module may use one of these conventional forms:

```nix
home-manager.users.${host.usernameLower} = {
  imports = homeModules;
};
```

or `home-manager.sharedModules = homeModules` when the modules genuinely apply to every managed user. Do not use `sharedModules` for user-specific modules if multi-user support would change behavior.

## Migration steps

1. Add pure graph tests for current ordering, shared-dependency deduplication, invalid and unknown names, malformed fields, and cycles.
2. Implement the strict resolver while retaining the current host recipe roots.
3. Mechanically rename `recipes` to `includes`, `base` to `systemModules`, and `hm` to `homeModules`.
4. Wrap every single system module in a list; remove reliance on `lib.flatten`.
5. Evaluate all hosts and inspect generated package/service options for accidental ordering changes.

Keep the declaration migration separate from unrelated recipe behavior changes.

## Acceptance criteria

- Every recipe declaration follows the exact three-field contract.
- Invalid names fail before filesystem path construction.
- Unknown fields and invalid field types fail with actionable messages.
- A synthetic cycle reports its complete dependency path.
- A diamond dependency appears once in stable first-occurrence order.
- Current host expansions contain the same recipes as before migration.
- The loader no longer calls `lib.flatten` on recipe output.
- All five host configurations evaluate successfully.

## Validation

Run the global checks from [README.md](README.md), plus the focused resolver tests. Include empty, absolute, repeated-separator, `.`-segment, and `..`-segment recipe names. Capture a before/after expansion list for every host and compare names and order.

Useful inspection:

```bash
rg '\b(recipes|base|hm)\s*=' config/recipe -g '*.nix'
rg '\b(includes|systemModules|homeModules)\s*=' config/recipe -g '*.nix'
```

The first command should have no declaration-field matches after migration. Local module options containing similar words are not part of this contract and should be reviewed manually.

## Non-goals

- Do not reorganize directories yet.
- Do not remove named recipes.
- Do not change which packages or services hosts receive.
- Do not migrate host identity out of `metadata`; that belongs to Enhancement 2.
