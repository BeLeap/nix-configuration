# Enhancement 4: Make platform capabilities complete

## Goal

Use the common and platform-specific fields from Enhancement 3 so one recipe can own a complete capability across NixOS, nix-darwin, and Home Manager. Host declarations must not remember manual pairs such as `1password` plus `1password/macos`.

Estimated implementation time: **2–4 hours**.

## Current problem

Several capabilities are split into shared and platform-specific recipes. Some pairs are composed indirectly through broader recipes; others are manually listed by every host. This permits invalid partial selections:

- shared CLI or Home Manager configuration without the platform application;
- a platform service without the shared package or aliases it expects;
- a platform foundation recipe that assumes another root recipe was also selected.

The most visible example is 1Password:

```nix
"1password"
"1password/macos"
```

or:

```nix
"1password"
"1password/nixos"
```

The invariant exists only in the reader’s memory even though all pieces represent one capability.

## Target composition pattern

Consolidate common and platform implementations into one ordinary recipe:

```text
config/recipe/1password/default.nix
```

Conceptual declaration:

```nix
_: {
  home = [
    ({pkgs, ...}: {
      home.packages = [pkgs._1password-cli];
    })
  ];

  darwin.system = [
    ({...}: {
      # Darwin application and integration
    })
  ];

  nixos.system = [
    ({...}: {
      # NixOS service and integration
    })
  ];
}
```

Every host selects only `1password`. NixOS assembly consumes `home` plus `nixos.system`; nix-darwin assembly consumes `home` plus `darwin.system`. The recipe remains one selectable capability while platform dispatch occurs only within its already-selected fields.

Platform-specific Home Manager differences use `nixos.home` and `darwin.home` in the same recipe when needed.

## Design rules

- Encode common behavior once in `system` or `home`.
- Encode only actual differences in `nixos` and `darwin` fragments.
- Keep recipe selection explicit; do not branch on `host.backend` inside modules or infer different recipe names from metadata.
- Use `darwin`, not `macos`, for the nix-darwin field and document any user-facing recipe names retained temporarily during migration.
- Do not retain separate shared and platform recipe paths when they have one capability identity and the field model expresses their differences directly.
- Keep separate recipes when features are independently selectable, not merely because their modules target different platforms.
- Add assertions for required external services or invalid combinations that field dispatch cannot express.

## Inventory work

Audit at least these families:

- `1password`, `1password/macos`, `1password/nixos`;
- `hm`, `hm/macos`, `hm/nixos`;
- `nix`, `nix/macos`, `nix/nixos`;
- `podman`, `podman/macos`;
- `nh/macos`, `nh/nixos`;
- `ws-cleanup/macos`, `ws-cleanup/nixos`;
- `vm` and `nixos/vm`.

For each family, record:

1. common system contribution;
2. common Home Manager contribution;
3. NixOS system and Home Manager differences;
4. Darwin system and Home Manager differences;
5. current parent recipes and host roots;
6. intended single selectable recipe name, or the reason separate recipes remain independently meaningful.

Do not force all families into the same shape when they represent genuinely independent features. The requirement is complete capability ownership, not superficial consolidation.

## Implementation steps

1. Capture current host expansion and evaluated package/service values for one family.
2. Move common contributions into the parent recipe’s `system` and `home` fields.
3. Move platform differences into its `nixos` and `darwin` fragments.
4. Update parent recipes and host roots to select only the consolidated recipe.
5. Remove obsolete platform recipe entrypoints after all references are gone.
6. Add assertions when a capability requires an external platform service that cannot be represented by field dispatch alone.
7. Compare effective module and package sets before and after each family migration.

Migrate one family per atomic revision where practical.

## Acceptance criteria

- No host manually selects both a shared capability and a platform-specific half of that capability.
- Selecting `1password` provides shared Home Manager configuration and the correct platform system implementation exactly once.
- Darwin assembly never receives NixOS contributions, and NixOS assembly never receives Darwin contributions.
- Common configuration is not duplicated across platform fragments.
- Platform differences remain explicit; no metadata-driven recipe selection or module conditionals are introduced.
- Separate recipes remain only where independent selection is meaningful.
- Every audited family has a documented public composition boundary.
- All five host configurations evaluate successfully.

## Validation

Run the global checks from [README.md](README.md). Inspect host roots and recipe dependencies:

```bash
rg '"(1password|hm|nix|podman|nh|ws-cleanup|vm)(/[^" ]+)?"' config -g '*.nix'
```

Use graph inspection to prove obsolete paired recipe names no longer occur in affected host expansions. Evaluate generated package and service values on at least one NixOS and one Darwin host for every consolidated family.

Search for platform-field duplication during review rather than relying only on textual equality; two functions with different formatting may still implement the same common behavior.

## Non-goals

- Do not infer recipe selection from host metadata.
- Do not add unsupported platform implementations for visual symmetry.
- Do not merge independently selectable features merely because they share a platform.
- Do not alter application settings while changing composition.
- Do not hide required external services behind silent checks.
