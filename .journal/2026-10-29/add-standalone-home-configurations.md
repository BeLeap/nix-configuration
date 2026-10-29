# Add standalone Home Manager configurations

## Outcome

- Added `homeConfigurations` entries named `<username>@<host>` for each host.
- Reused each host's Home Manager recipe modules and `{ inputs, host }` module arguments.
- Selected the Home Manager flake input by backend and reused the integrated system's package set so overlays and nixpkgs configuration match.
- Extracted recipe graph resolution into `config/recipe-modules.nix` for shared use by integrated and standalone configurations.

## Validation

- Ran Alejandra through `nix shell nixpkgs#alejandra` on the changed Nix files; formatting succeeded.
- Did not run evaluation or tests.

## Home Manager-only hosts

- Added the home-manager backend, which requires an explicit platform such as x86_64-linux and creates no NixOS or Darwin system output.
- Standalone package sets reuse the shared overlays and nixpkgs configuration. Recipe platform fragments follow the declared platform.

## Clarification

- Integrated hosts reuse the system package set. Home Manager-only hosts import the platform-matched nixpkgs with the same overlay list and nixpkgs configuration.
- Focused evaluation exposed that standalone hosts need an explicit home directory; added platform defaults and the optional homeDirectory override.

## Follow-up validation

- Evaluated a temporary Home Manager-only x86_64-linux host using the shared HM recipe; its activation package resolved to a Home Manager generation derivation.
- Confirmed the temporary host did not appear in nixosConfigurations.
- A full activation-package evaluation with the default recipe set waited on a cache connection and was stopped; no build or test suite was run.
