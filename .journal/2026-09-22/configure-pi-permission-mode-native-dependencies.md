# Configure Pi permission-mode native dependencies

## Outcome

- Read the official `pi-permission-modes` README: https://github.com/wynainfo/pi-permission-modes/blob/main/README.md.
- The README says macOS uses the built-in `sandbox-exec`, so no extra macOS package is required.
- Linux and WSL2 require `bubblewrap` (`bwrap`), `socat`, and `ripgrep` on `PATH`.
- Updated `config/recipe/pi/default.nix` so the wrapped Pi executable always exposes `ripgrep`, and exposes Nixpkgs `bubblewrap` and `socat` only on Linux. This keeps the dependency declaration scoped to Pi rather than adding Linux-only tools to every home profile.

## Validation

- `alejandra --check config/recipe/pi/default.nix`: passed.
- `statix check config/recipe/pi/default.nix`: passed.
- Nixpkgs attribute checks for Linux `bubblewrap`, `socat`, and `ripgrep`: passed.
- `nix flake check --no-build --show-trace`: passed after a first attempt was interrupted by a transient Nix store/cache error involving an invalid `starship` derivation.
- Darwin system derivation evaluation passed for `beleap-m1air`, `beleap-macmini`, and `csjang-m3pro`.
- NixOS system derivation evaluation passed for `vm-arm64-Darwin-personal` and `vm-arm64-Darwin-work`.
