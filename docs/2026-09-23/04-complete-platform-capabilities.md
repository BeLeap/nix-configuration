# Enhancement 4: Make platform capabilities complete

## Goal

Ensure every concrete platform capability includes all modules required for that capability. Host declarations must not need to remember manual pairs such as `1password` plus `1password/macos`.

Estimated implementation time: **2–4 hours**.

## Current problem

Several capabilities are split into shared and platform-specific recipes. Some pairs are composed indirectly through broad profiles; others are manually listed by every host. This permits invalid partial selections:

- shared CLI or Home Manager configuration without the platform application;
- a platform service without the shared package or aliases it expects;
- a platform base profile that assumes another root profile was also selected.

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

The invariant exists only in the reader’s memory.

## Target composition pattern

Use a shared implementation plus complete concrete variants:

```text
modules/home/common/1password.nix
modules/system/darwin/1password.nix
modules/system/nixos/1password.nix
profiles/capabilities/1password-darwin.nix
profiles/capabilities/1password-nixos.nix
```

Conceptual declarations:

```nix
"1password/darwin" = {
  includes = ["1password/common"];
  systemModules = [../modules/system/darwin/1password.nix];
};

"1password/nixos" = {
  includes = ["1password/common"];
  systemModules = [../modules/system/nixos/1password.nix];
};
```

Hosts select only the concrete capability. Shared implementations may remain registry entries for composition, but should not be selected directly by hosts unless a shared-only use case is documented.

## Design rules

- Encode dependencies in the capability declaration, not in host lists.
- Keep platform choice explicit; do not branch on `host.os` inside a shared module.
- Use names consistently: prefer `darwin` for nix-darwin module variants and `nixos` for NixOS variants, or document a repository-wide alternative.
- A concrete capability must be independently selectable after required platform foundation modules are present.
- Do not create combined profiles for every theoretical role/platform combination. Create variants only where implementation actually differs.

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

1. shared implementation;
2. platform implementation;
3. required platform foundation;
4. current selecting profiles and hosts;
5. intended public selectable name.

Do not force all families into the same shape when there is no shared implementation. The requirement is completeness, not superficial symmetry.

## Implementation steps

1. Add includes from concrete variants to their shared capability where missing.
2. Update profiles and hosts to select only concrete variants.
3. Remove redundant direct selections of shared halves.
4. Add assertions when a capability requires an external platform service that cannot be represented by inclusion alone.
5. Compare effective module and package sets before and after each family migration.

## Acceptance criteria

- No host manually selects both a shared capability and one of its concrete platform variants.
- Selecting `1password/darwin` or `1password/nixos` includes the shared 1Password Home Manager configuration exactly once.
- Shared dependencies are deduplicated by the loader.
- Platform differences remain explicit; no metadata-driven platform conditionals are introduced.
- Every audited family has documented public and internal composition boundaries.
- All five host configurations evaluate successfully.

## Validation

Run the global checks from [README.md](README.md). Inspect host roots and recipe dependencies:

```bash
rg '"(1password|hm|nix|podman|nh|ws-cleanup|vm)(/[^" ]+)?"' config -g '*.nix'
```

Use the graph inspection developed in Enhancement 1 to prove each shared capability occurs once in every affected host expansion.

## Non-goals

- Do not automatically infer platform variants from host metadata.
- Do not add unsupported platform implementations for visual symmetry.
- Do not alter application settings while changing composition.
- Do not hide required external services behind silent checks.
