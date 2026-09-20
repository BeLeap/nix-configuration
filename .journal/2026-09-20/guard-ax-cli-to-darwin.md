# Guard `ax-cli` to Darwin

- Updated `config/recipe/overlay/pkgs/beleap-utils/default.nix` so `ax-cli` is added to wrapped utility `PATH` only when `stdenv.hostPlatform.isDarwin` is true.
- This keeps the shared `beleap-utils` package evaluable for Linux while retaining `ax` support for the Darwin-only `click-notification` script.

## Validation

- `alejandra --check config/recipe/overlay/pkgs/beleap-utils/default.nix`: passed.
- `statix check config/recipe/overlay/pkgs/beleap-utils/default.nix`: passed.
- `nix flake check --no-build --show-trace`: passed.
- `nix flake check --all-systems --no-build --show-trace`: passed for `aarch64-darwin` and `aarch64-linux`.

## Working tree note

- The existing modification to `config/recipe/firefox/default.nix` was not changed.
