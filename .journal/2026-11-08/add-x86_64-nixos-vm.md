# Add an x86_64 NixOS VM

## Outcome

- Added `vm-x86_64-Darwin-personal` for `x86_64-linux` with the existing personal VM recipes.
- Updated `bin/run-vm` to accept an optional architecture. `bin/run-vm personal x86_64` selects the new VM.
- Kept x86_64 binfmt emulation on ARM guests. The x86_64 guest now leaves `boot.binfmt.emulatedSystems` empty.
- Documented the x86_64 VM command in `README.md`.

## Validation

- `nix run nixpkgs#alejandra -- --check .`: passed.
- `nix run nixpkgs#statix -- check .`: passed.
- `nix run nixpkgs#deadnix -- .`: passed.
- `bash -n bin/run-vm` and runner argument/target-selection checks: passed.
- Nix evaluation listed the new host and evaluated its VM derivation path.
- The x86_64 system evaluated as `x86_64-linux`. Its binfmt list is empty, while the ARM guest retains `x86_64-linux` emulation.
- `nix build '.#nixosConfigurations.vm-x86_64-Darwin-personal.config.system.build.vm' --accept-flake-config --no-link` timed out after 900 seconds before producing the VM artifact.
- The build planned 761 derivations. Nix ignored substitutes from `beleap-nix-overlay.cachix.org` because their signatures did not match the configured trusted keys.
