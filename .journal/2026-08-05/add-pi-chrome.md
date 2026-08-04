# Add pi-chrome

Added the pinned `pi-chrome` 0.15.46 package to Pi's declarative settings. The package provides explicitly authorized access to the existing Chrome profile through a loopback-only bridge.

After applying the Home Manager configuration, finish the companion extension setup with `/chrome onboard`, reload Pi, then verify and authorize it with `/chrome doctor` and `/chrome authorize`.

## Validation

- Confirmed 0.15.46 is the current package version from the Pi package gallery and upstream package manifest.
- Alejandra's formatting check passed on the changed Nix file.
- `nix flake check --no-build` started evaluating successfully with a writable temporary cache, but an unrelated existing Starship derivation reference was invalid while evaluating the VM configuration, so the full check did not complete.
- Jujutsu could not snapshot the working copy because sandbox policy blocks access to `.envrc`; `jj --ignore-working-copy` therefore showed only its stale, clean snapshot.
