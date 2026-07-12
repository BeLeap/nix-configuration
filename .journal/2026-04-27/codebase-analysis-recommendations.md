# Codebase Analysis Recommendations

Reviewed the Nix flake structure, host metadata, recipe loader, representative recipes, utility scripts, CI workflows, and prior recommendation notes.

Verification run:

- `jj status`: clean before analysis.
- `nix flake show --accept-flake-config`: evaluated outputs successfully.
- `nix run nixpkgs#alejandra -- --check .`: passed.
- `nix run nixpkgs#statix -- check .`: passed.
- `nix run nixpkgs#deadnix -- .`: reported unused lambda-pattern inputs in `lib/mkSystem.nix`.

Current improvement candidates:

- Fix stale README references to removed/renamed paths: `config/recipes.nix` and `config/default.nix`.
- Clean up `lib/mkSystem.nix` input destructuring so `deadnix` passes.
- Add CI coverage for NixOS VM outputs or at least evaluate/build one VM output on the macOS runner.
- Improve `beleap-utils` shell scripts with argument validation, quoting, strict mode, and fewer hardcoded branch assumptions.
- Revisit destructive workspace cleanup: it uses `find ... -atime ... -exec rm -rf` on first-level `~/ws` directories; safer dry-run/quarantine behavior would reduce blast radius.
- Move long-running launchd logs out of shared `/tmp` into per-user state/log locations.
- Derive Darwin `nixpkgs.hostPlatform` from host metadata instead of hardcoding `aarch64-darwin`.
