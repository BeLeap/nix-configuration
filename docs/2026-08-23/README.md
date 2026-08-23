# Recipe architecture enhancement handoff

This directory turns the 2026-08-23 recipe architecture review into five coding-agent handoffs. The goal is to preserve explicit host composition and cross-layer recipes while replacing permissive custom machinery with strict declarations and clear responsibility boundaries.

## Recommended execution order

1. [Harden the recipe loader](01-harden-recipe-loader.md)
2. [Simplify input and host plumbing](02-simplify-input-plumbing.md)
3. [Model common and platform-specific recipe fields](03-model-common-and-platform-recipe-fields.md)
4. [Make platform capabilities complete](04-complete-platform-capabilities.md)
5. [Split broad recipes and extract Mac mini services](05-split-broad-recipes-and-host-services.md)

Complete and validate one document before starting the next. Each document may require several atomic Jujutsu changes; do not combine all five enhancements into one revision.

## Global invariants

- Keep recipe selection explicit. Do not introduce a separate profile type or reintroduce metadata-driven feature branching.
- Preserve behavior during structural moves. Package or service policy changes require a separate revision and explicit rationale.
- Fail clearly on invalid declarations. Do not add silent compatibility fallbacks.
- Preserve unrelated working-copy changes. Start every handoff with `jj status` and inspect focused diffs with `jj diff`.
- Declare common behavior once and represent only actual NixOS, nix-darwin, or Home Manager differences in platform fragments.

## Baseline validation

Run these after every logical change:

```bash
alejandra --check .
statix check .
deadnix .
nix flake check --show-trace
```

`nix flake check` does not fully evaluate the custom `darwinConfigurations` output on this machine. Also evaluate all Darwin hosts explicitly:

```bash
for host in beleap-m1air beleap-macmini csjang-m3pro; do
  nix eval ".#darwinConfigurations.${host}.system.drvPath" --raw >/dev/null
done
```

Evaluate both NixOS hosts explicitly when assembly code changes:

```bash
for host in vm-arm64-Darwin-personal vm-arm64-Darwin-work; do
  nix eval ".#nixosConfigurations.${host}.config.system.build.toplevel.drvPath" --raw >/dev/null
done
```

Record significant outcomes, validation failures, and unresolved limitations in an append-only `.journal/<date>/...md` entry.

## Design references

- NixOS manual via Context7: `/websites/nixos_manual_nixos_unstable`
  - Standard modules use `imports`, `options`, and `config`.
  - Assertions should reject invalid combinations with actionable messages.
  - `specialArgs` is appropriate for values required while resolving imports.
- Home Manager via Context7: `/nix-community/home-manager`
  - Reusable Home Manager modules should be ordinary modules.
  - `home-manager.sharedModules` applies modules to every managed user.
  - `home-manager.extraSpecialArgs` explicitly passes external arguments to Home Manager modules.

## Completion definition

The architecture work is complete when every host root and include resolves through one uniform recipe model, common configuration is declared once, platform differences remain explicit, cross-layer capabilities remain atomic, the loader rejects malformed graphs, adding a flake input no longer requires editing `lib/mkSystem.nix`, and all five host configurations evaluate successfully.
