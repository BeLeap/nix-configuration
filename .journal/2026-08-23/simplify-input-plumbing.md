# Simplify input and host plumbing

## Outcome

- Passed the actual flake `inputs` set from `flake.nix` through `lib/build-configs.nix`, `lib/mkSystem.nix`, and `config/recipe-assembly.nix` without `callPackage` or `callPackageWith` injection.
- Changed system assembly to the curried `{inputs, lib}: {host}:` constructor and passed `{inputs, host}` as system and Home Manager special arguments.
- Changed recipe constructors that use external flake inputs to receive `{inputs, ...}` and reference qualified inputs such as `inputs.agenix`, `inputs.try`, and `inputs.home-manager`.
- Renamed module-facing host identity from `metadata` to `host` throughout system and Home Manager modules.
- Updated the README assembly description. Package, service, launch-agent, and user-setting policy was not changed.

## Validation

- `nix-instantiate --parse` passed for all 84 Nix files under `config` and `lib`, plus `flake.nix`.
- `alejandra --check .`: passed.
- `statix check .`: passed.
- `deadnix .`: exits successfully and reports only the pre-existing unused `pyf` argument in `config/recipe/overlay/default.nix`; `lib/mkSystem.nix` has no unused declarations.
- `nix flake check --show-trace`: passed. Existing Home Manager default-change warnings remain.
- Output names remain `darwinConfigurations = ["beleap-m1air" "beleap-macmini" "csjang-m3pro"]` and `nixosConfigurations = ["vm-arm64-Darwin-personal" "vm-arm64-Darwin-work"]`.
- All five system derivation paths evaluated successfully.
- Resolved host values remain: Darwin `aarch64-darwin` with users `beleap`, `beleap`, and `cs.jang`; NixOS `aarch64-linux` with users `beleap` and `cs.jang`.
- The legacy plumbing search is clean in source content; the only remaining `metadata` match is the existing factory filename `lib/metadata.nix`.

## Notes

- A first NixOS platform probe used the unavailable `config.nixpkgs.hostPlatform.system` option. The corrected probe uses `pkgs.stdenv.hostPlatform.system`; host evaluation itself was successful throughout.
- No Jujutsu revision was created because committing was not requested.
