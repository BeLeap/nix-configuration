# Evaluate recipe architecture

Reviewed the host inventory, recipe dependency graph, recipe loader, system assembly, representative system/Home Manager recipes, and prior recipe-refactoring journal entries.

## Findings

- The recipe concept is useful: host composition is explicit, previous metadata-driven feature branching has been reduced, and the current graph is acyclic with no duplicate expansion for any of the five hosts.
- The custom recipe DSL is too permissive. Recipe outputs can vary between modules and lists, missing `base`/`hm` fields silently become empty lists, unknown fields are not rejected, and `lib.flatten` hides shape errors.
- Recursive inclusion has no cycle detection or deduplication. The current graph does not trigger either failure mode, but a future shared dependency can duplicate module definitions and a cycle will fail through uncontrolled recursion.
- `lib/mkSystem.nix` uses its entire call-package argument set as `inputs`, forcing every flake input to be named in the function signature. This creates manual plumbing and accounts for many deadnix warnings.
- Recipe taxonomy mixes feature modules, platform adapters, profiles, host modules, overlays, and package definitions. Some capabilities require manual paired selection, such as `1password` plus `1password/macos` or `1password/nixos`.
- `config/hosts.nix` repeats substantial personal-Darwin and NixOS-VM composition. The explicit lists remain readable, but composed profiles could encode valid combinations and eliminate paired-selection invariants.
- The `default` recipe is a broad workstation/development profile rather than a minimal baseline; it includes development, Firefox, and Kubernetes for every host.
- `beleap-macmini` is a host recipe containing substantial Ollama and ZeroClaw service implementations. Those implementations would be easier to change and test as feature modules with host-level settings.

## Recommended direction

Keep recipes as the user-facing composition concept, but migrate their internals toward standard Nix modules and a strict profile registry:

1. Harden the loader with an explicit schema (`includes`, `systemModules`, `homeModules`), missing-path checks, allowed-key checks, cycle detection, and stable deduplication.
2. Pass a compact `{ inputs, host }` assembly context explicitly instead of using `callPackage` as global dependency injection. Keep immutable host identity in `host`; use module options for configurable feature behavior.
3. Separate `modules/`, `profiles/`, `hosts/`, `overlays/`, and `pkgs/`. Profiles should compose modules only; host modules should contain host-specific values only.
4. Make concrete platform capabilities complete: for example, `1password/darwin` should include the shared 1Password Home Manager module so hosts cannot select only half of the feature.
5. Split the broad default profile into at least `core` and `development`, then extract Ollama/ZeroClaw from the Mac mini host recipe.

The NixOS manual documents standard modules around `imports`, `options`, and `config`; Home Manager documents `sharedModules` and `extraSpecialArgs` for reusable user modules and explicit external arguments. These standard mechanisms can replace most of the custom `base`/`hm` wrapping while preserving explicit profile selection.

## Validation

- Recipe graph inspection: five hosts expand to 34–45 unique recipes each, with no cycles or duplicates in the current graph.
- `alejandra --check .`: passed.
- `statix check .`: passed.
- `deadnix .`: reported existing unused arguments, especially the flake-input plumbing in `lib/mkSystem.nix`, plus three smaller recipe warnings.
- `nix flake check --show-trace`: passed; it emitted existing Home Manager default-change warnings and noted that incompatible `aarch64-linux` checks were omitted on Darwin.
- Darwin evaluations passed for `beleap-m1air`, `beleap-macmini`, and `csjang-m3pro`. One combined command was interrupted after the first two and the third was rerun successfully.
- No source configuration was changed by this review. The working copy was clean after a concurrent change was committed during the analysis.

## Later state note

After the review journal was written, `config/recipe/macos/personal/default.nix` became modified again by concurrent work. That source change is unrelated to this analysis and was not included in the validation snapshot.

## Coding-agent handoff documentation

Created `docs/2026-09-23/README.md` and one detailed Markdown handoff for each of the five recommended enhancements. Each handoff defines the goal, current problem, target structure, implementation boundaries, ordered steps, explicit error behavior, acceptance criteria, validation, and non-goals. The index records cross-cutting invariants, Jujutsu workflow expectations, full-host evaluation commands, and NixOS/Home Manager documentation references.

Validation:

- A Ruby check confirmed all six files have an H1 and all relative Markdown links resolve.
- `markdownlint` was unavailable, so no markdownlint check was run.
- Reviewed the focused Jujutsu summary and docs-only diff stat: six files, 726 added lines.
- Existing concurrent Discord and macOS personal recipe changes were left untouched.
