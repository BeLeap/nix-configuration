# Preserve cross-layer recipes in the architecture handoff

## Outcome

Revised Enhancement 3 so recipes remain the public, atomic capability boundary. A recipe may own both system and Home Manager modules; the architecture separation now targets mixed responsibilities such as profiles, concrete hosts, overlays, and package derivations rather than splitting cohesive capabilities by module system.

The revised handoff:

- distinguishes recipes from profiles and optional extracted implementation modules;
- permits small inline modules within recipes;
- requires profiles to compose recipes rather than separate system/Home Manager halves;
- keeps directory layout flexible while requiring an explicit selectable-name registry;
- updates migration guidance, classification questions, acceptance criteria, and non-goals accordingly.

Updated the handoff index to use the same cross-layer recipe model.

## Validation

Jujutsu status and diff inspection was blocked because the sandbox could not stat the repository's protected `.envrc`. This limitation was left explicit rather than bypassed. Markdown structure and relative links were checked separately after the edits.

A Ruby validation confirmed all six handoff Markdown files retain an H1 and all relative Markdown links resolve. A focused terminology search found no stale handoff title or contradictory direction to split cohesive system/Home Manager recipes.

## Correction: profiles are not a separate architecture layer

The first revision still gave composition-oriented “profiles” a special directory and responsibility. That contradicted the intended recipe model. Updated the handoffs again so every declaration has equal recipe status and may be a root, include, composition, module owner, or a combination of these roles.

The corrected documentation removes the proposed `profiles/` hierarchy, defines profile/capability/host terminology as descriptive rather than structural, and limits namespace separation to non-recipe implementations such as overlays, packages, and optionally extracted modules. Enhancement 4 now describes broader parent recipes rather than profiles. Enhancement 5 now creates ordinary composition recipes and was renamed to `05-split-broad-recipes-and-host-services.md`.

Validation confirmed all six Markdown files have an H1, all relative links resolve, the old Enhancement 5 filename has no remaining references, and remaining uses of “profile” only prohibit treating it as a special type.

## Correction: use convention-based recipe resolution

Removed the proposed explicit recipe registry because it would duplicate the recipe directory and require maintenance for every addition. Enhancement 3 now keeps the existing `<name> -> config/recipe/<name>/default.nix` convention, requires strict validation against empty, absolute, and traversing names, and treats optional recursive discovery as diagnostics rather than a source of truth.

Also updated Enhancements 4 and 5 to remove registry assumptions and renamed Enhancement 3 to `03-separate-recipe-and-implementation-namespaces.md`. Validation confirmed all six handoff files retain an H1, all relative links resolve, and no stale references to either renamed handoff remain.

## Clarify recipes versus top-level modules

Updated Enhancement 3 to distinguish recipes and modules by consumer contract rather than directory taxonomy or platform grouping. Recipes remain the only selectable units. `config/modules/` is now documented as an optional non-selectable API library justified only by reusable typed options, multiple recipe consumers, shared platform infrastructure, or isolated module testing.

The handoff now explicitly says that `darwin`/`nixos` grouping only communicates compatibility, that one-to-one module wrappers without an independent API are likely ceremony, and that the module hierarchy must not mirror the recipe hierarchy by default.

## Correction: drop the top-level module hierarchy

Removed the proposed `config/modules/` hierarchy from the handoffs entirely. Standard NixOS, nix-darwin, and Home Manager modules remain values contributed by ordinary recipes through `systemModules` and `homeModules`; reusable service behavior is extracted into reusable recipes rather than a parallel non-selectable module library.

Enhancement 4 now keeps shared and platform-specific 1Password implementation in recipes. Enhancement 5 now extracts Ollama and ZeroClaw into independently selectable recipes, with an optional broader recipe composing them.

## Simplify recipe field names

Updated the proposed strict recipe schema from `systemModules` and `homeModules` to `system` and `home`. The recipe contract already establishes that both fields contain module lists, so the `Modules` suffix was redundant. Updated declaration examples, migration guidance, validation searches, classification guidance, and platform-capability examples across Enhancements 1, 3, and 4.

## Keep the overlay with its recipe

Removed the default proposal to move the overlay implementation into a top-level `overlays/` directory. The selectable overlay recipe now owns its private `overlay.nix` helper. A top-level overlay directory is reserved for a future independently consumed overlay.

The package derivation still moves to `pkgs/` because its nested `default.nix` can masquerade as the convention-resolved recipe `overlay/pkgs/beleap-utils`. Updated migration, classification, acceptance, and validation guidance accordingly.

## Add common and platform-specific recipe fields

Added a new Enhancement 3 rather than rewriting the completed strict-loader baseline. The new contract uses common `system` and `home` lists plus additive `nixos.system`, `nixos.home`, `darwin.system`, and `darwin.home` fragments. This avoids duplicating portable configuration while modeling platform differences symmetrically.

The handoff specifies per-recipe common-before-platform ordering, explicit assembly backend dispatch rather than metadata-driven recipe selection, strict nested validation, behavior-neutral migration, and cross-backend tests. Renumbered the prior Enhancements 3–5 to 4–6, restored Enhancement 1 to its implemented `systemModules`/`homeModules` baseline, and revised capability completion so one recipe can own common plus both platform implementations.

## Correction: colocate the overlay-owned package

The earlier guidance still moved `beleap-utils` to top-level `pkgs/`. Revised Enhancement 4 to keep the one-consumer derivation with its overlay recipe as `config/recipe/overlay/beleap-utils.nix`, with sources under the adjacent `scripts/` directory. This removes the nested `default.nix` recipe-name collision without separating implementation from its owner.

Renamed the handoff to `04-keep-recipe-entrypoints-unambiguous.md` and reduced its scope and estimate. Top-level `pkgs/` or `overlays/` directories are now justified only by independent consumers.

Clarified its Current problem section afterward: colocating private files with recipes is intentional and harmless. The sole collision is the nested `overlay/pkgs/beleap-utils/default.nix`, which matches the recipe entrypoint convention despite returning a package derivation.

## Correction: remove the entrypoint-ambiguity enhancement

Removed Enhancement 4 after concluding that the nested package `default.nix` causes no practical problem under explicit name resolution and strict declaration validation. The overlay and package layout therefore remains unchanged.

Moved recipe-name path validation into Enhancement 1, renumbered capability completion and broad-recipe/service extraction back to Enhancements 4 and 5, and restored the handoff index to five enhancements.
