# Enhancement 3: Separate architecture layers

## Goal

Give modules, profiles, hosts, overlays, and packages distinct locations and responsibilities. Keep “recipe” as the user-facing composition idea, not as a directory containing every kind of Nix code.

Estimated implementation time: **4–8 hours**, preferably split into several path-focused Jujutsu revisions.

## Current problem

`config/recipe/` currently mixes:

- reusable system modules;
- reusable Home Manager modules;
- platform adapters;
- broad profiles such as `default`, `development`, `personal`, and `work`;
- concrete host implementations;
- overlay definitions;
- package derivations and shell-script sources.

A `default.nix` path does not reveal whether it is selectable, compositional, host-specific, or a package implementation. This makes discovery, validation, and ownership harder.

## Target structure

```text
config/
  hosts/
    default.nix                 # host inventory
    beleap-m1air.nix
    beleap-macmini.nix
    csjang-m3pro.nix
    vm-arm64-Darwin-personal.nix
    vm-arm64-Darwin-work.nix
  modules/
    system/
      common/
      darwin/
      nixos/
    home/
      common/
      darwin/
      nixos/
  profiles/
    core/
    development/
    personal/
    work/
    darwin/
    nixos-vm/
  recipe-registry.nix
overlays/
  default.nix
pkgs/
  beleap-utils/
```

Exact subdirectory depth may change, but the responsibilities below are mandatory.

## Layer responsibilities

### Modules

- Contain implementation.
- Are standard NixOS, nix-darwin, or Home Manager modules.
- May declare typed options and assertions.
- Must not select role profiles or concrete hosts.
- Platform-specific modules live under an explicit platform directory.

### Profiles

- Compose named capabilities and modules.
- Contain little or no direct option implementation.
- Represent reusable policy such as core, development, personal, work, GUI, or VM.
- Must not contain hostname-specific values.

### Hosts

- Contain facts and settings unique to one machine.
- Select profiles and enable/configure feature modules.
- Must not carry reusable service implementations or package derivations.

### Overlays and packages

- Live outside the selectable recipe namespace.
- Overlay files only extend package sets.
- `pkgs/` contains derivations and their source files.
- A package `default.nix` must never be mistaken for a recipe entrypoint.

## Registry design

Use an explicit registry mapping stable recipe/profile names to declarations or paths. Directory traversal should not define the public API.

Example shape:

```nix
{
  core = import ./profiles/core;
  development = import ./profiles/development;
  "host/beleap-m1air" = import ./hosts/beleap-m1air.nix;
}
```

The strict loader from Enhancement 1 should resolve names only through this registry. This makes moves explicit, prevents accidental selection of package files, and gives unknown-name errors a complete list of valid names.

## Migration sequence

1. Add the registry while paths still point to current recipe locations.
2. Move `config/recipe/overlay` to `overlays/` and its package implementation to `pkgs/`.
3. Move concrete host recipes into `config/hosts/` without changing their contents.
4. Move reusable implementations into `config/modules/system` or `config/modules/home`.
5. Move composition-only declarations into `config/profiles/`, then update README and internal links.

Use `jj diff --summary` after every move. Prefer a move-only revision followed by a behavior-neutral import-fix revision when Jujutsu cannot clearly represent both together.

## Classification guidance

Ask these questions for each existing recipe:

1. Does it implement options or services? Move it to `modules/`.
2. Does it only include other capabilities? Move it to `profiles/`.
3. Is it used by exactly one physical or virtual host because of machine facts? Move it to `hosts/`.
4. Does it alter `nixpkgs.overlays`? Move it to `overlays/`.
5. Does it build a package? Move it to `pkgs/`.

If a file does more than one, split it before moving it.

## Acceptance criteria

- Every selectable name is declared in one explicit registry.
- Package and overlay implementations are outside the recipe/profile namespace.
- Profiles contain composition, not substantial implementation.
- Host files contain host-specific values, not reusable daemons or scripts.
- Platform-specific modules have an explicit `darwin` or `nixos` boundary.
- No stale imports or documentation references point to `config/recipe/...` paths that were moved.
- All five hosts retain their pre-migration behavior and evaluate successfully.

## Validation

Run the global checks from [README.md](README.md). Also search for stale paths:

```bash
rg 'config/recipe|\.\./recipe|/recipe/' . -g '*.nix' -g '*.md'
```

Review each remaining match. References may remain only when the file intentionally has not migrated or when documenting historical paths.

## Non-goals

- Do not change which profiles hosts select while moving files.
- Do not rename user-visible commands or packages.
- Do not merge Darwin and NixOS implementations into conditional modules merely to reduce file count.
- Do not introduce flake-parts solely for directory organization.
