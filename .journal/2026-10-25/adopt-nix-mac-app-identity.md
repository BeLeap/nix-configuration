# Adopt nix-mac-app-identity for WezTerm

- Added `nix-mac-app-identity` to `flake.nix` and followed `nixpkgs-unstable`.
- Imported the upstream Darwin Home Manager module.
- Stabilized `pkgs.wezterm-upstream` through `targets.darwin.appIdentity.apps`.
- Updated the WezTerm Dock path to use the stabilized bundle.
- Kept Discord and Firefox as Homebrew casks.
- Left the other app package recipes unchanged.

## Validation

- `alejandra --check` passed for the changed Nix files.
- `statix check` passed for the changed Nix files.
- All three Darwin configurations evaluated. Each lists WezTerm as its only app identity package.
- The stabilized WezTerm derivation built.
- `codesign --verify --deep --strict` passed for `WezTerm.app`.
- The designated requirement is `identifier "com.github.wez.wezterm"`.
- `nix flake check --all-systems --no-build --show-trace` stopped in unchanged `config/recipe/starship/default.nix:17`. Evaluation tried to read `/nix/store/ab40gp4c9lc5ihvq18nxljyjhr5rs1ng-starship-1.25.1/share/starship/presets/bracketed-segments.toml`, but its derivation path `c6jl70swzmlvy6wzgl1y2a711vjf7al6-starship-1.25.1.drv` was invalid.
