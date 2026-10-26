# Add standalone Home Manager configurations

## Outcome

- Added `homeConfigurations` entries named `<username>@<host>` for each host.
- Reused each host's Home Manager recipe modules and `{ inputs, host }` module arguments.
- Selected the Home Manager flake input by backend and reused the integrated system's package set so overlays and nixpkgs configuration match.
- Extracted recipe graph resolution into `config/recipe-modules.nix` for shared use by integrated and standalone configurations.

## Validation

- Ran Alejandra through `nix shell nixpkgs#alejandra` on the changed Nix files; formatting succeeded.
- Did not run evaluation or tests.
