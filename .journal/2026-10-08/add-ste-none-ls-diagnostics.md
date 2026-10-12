# Add ste diagnostics to none-ls

- Added `ste` as a pinned Go package from upstream commit `922c9773d0004f4c40b2e1373db9ed949321373d`.
- Added the package to Nixvim's `extraPackages` so the Neovim wrapper can find `ste`.
- Registered diagnostics for `markdown`, `text`, `rst`, and `mdx` buffers.
- The source sends the current buffer through stdin to `ste lint --format=json`.
- The source runs in the buffer directory so `ste` can find the nearest `.ste.yml` file.
- The source maps finding positions, rule IDs, severities, and suggestions to none-ls diagnostics.
- A first implementation loaded `ste_none_ls` with `require()`. The headless test showed Nixvim did not expose that extra file during `settings.sources` setup.
- The final implementation embeds the Lua source expression from `ste_none_ls.lua` into `settings.sources` with `builtins.readFile`.

## Validation

- Nix parsing and Alejandra formatting checks passed.
- `luajit -b` passed for `config/recipe/neovim/ste_none_ls.lua`.
- `nix build .#darwinConfigurations.beleap-m1air.system --accept-flake-config --no-link` passed.
- A headless Neovim test confirmed default and `.ste.yml` findings, suggestions, zero-based diagnostic positions, and clearing after clean text.
- The packaged CLI reported `ste 0-unstable-2026-07-29`.
- No system activation was performed.

## Follow-up: move the package to nix-overlay

- Moved the Go package definition to the BeLeap overlay and changed Neovim to use `pkgs.ste`.
- Updated `flake.lock` to pin overlay commit `b350934d8870bb24f798478a4a57ae83f654dc30`.
- Committed the overlay package as `b350934d` and pushed it to `master`.
- GitHub reported that the push bypassed the required `success` status check.
- After the move, the `beleap-m1air` system build and headless Neovim test passed with `ste` from `pkgs.ste`.
- No system activation was performed after the move.
- The `nix-configuration` lock and consumer changes remain uncommitted.
