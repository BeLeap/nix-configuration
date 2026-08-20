# Fix Discord macOS code-signature regression

- Added an overlay in `config/recipe/overlay/default.nix` that overrides both `pkgs.discord` and `pkgs.unstable.discord` with `source.modules = {}`.
- Root cause confirmed: nixpkgs extracts Discord's separately fetched modules into `Discord.app/Contents/Resources/modules` after the upstream Developer ID/notarized signature was created. The resulting app failed `codesign --verify --deep --strict` and `spctl` with `a sealed resource is missing or invalid`.
- `dontStrip = false` produced a much larger app and did not make the signature valid. `dontFixup = true` alone also left the added-module resource failure.
- Validation:
  - unstable Discord 0.0.406 output: `/nix/store/kn58k7ldg030nbyl68b2n7dgpgv373v2-discord-0.0.406`
  - `codesign --verify --deep --strict`: passed
  - `spctl --assess --type execute`: accepted as `Notarized Developer ID`
  - app size reduced to about 478 MiB; bundled module file count is 0
  - stable Discord 0.0.390 was also built and passed the same signature checks
  - `darwin-rebuild build --flake .#beleap-m1air`: passed
  - Alejandra check: passed
- `nix flake check --no-build` remains blocked by an unrelated invalid cached `starship-1.25.1.drv` while evaluating `nixosConfigurations.vm-arm64-Darwin-personal`.
- The pre-existing `config/recipe/macos/personal/default.nix` change to use `pkgs.unstable.discord` was preserved; no system switch was performed.
