# Diagnose Neovim invalid inlay-hint column

## Findings

- The screenshot reports `Invalid 'col': out of range` in Neovim 0.12.5 at `vim/lsp/inlay_hint.lua:362`.
- The failing call is Neovim's built-in inlay-hint decoration provider calling `nvim_buf_set_extmark`.
- The live LSP log identifies `clangd` 21.1.8 as the active client for `/Users/beleap/pj/github.com/beleap/COSE451/HW1/src/filter.c`.
- `clangd` reports no compilation database and uses its fallback compile command for that C file.
- The Neovim configuration enables all discovered LSP configs, enables inlay hints, and enables on-type formatting.
- The log shows repeated buffer changes, inlay-hint requests, semantic-token requests, and on-type formatting requests immediately before the errors.
- A headless check confirmed `vim.str_byteindex` clamps out-of-range positions to the end of the line. The available logs do not include inlay-hint response payloads.

## Assessment

- The error occurs when Neovim tries to render an inlay hint at a byte column that exceeds the current line length.
- `clangd` supplies the hint data. The evidence does not distinguish a malformed hint from stale hint data after edits or on-type formatting.
- The missing compilation database is relevant context, but the logs do not prove that it caused the invalid column.

## Immediate workaround

- In the affected buffer, run `:lua vim.lsp.inlay_hint.enable(false, { bufnr = 0 })`.
- This disables inlay hints for the current buffer. It leaves clangd diagnostics, completion, and navigation enabled.

## Validation and limits

- Checked the installed Neovim runtime source, active LSP logs, clangd version, and current Nixvim configuration.
- No configuration change or system activation was performed.
- Capture the hint response or disable on-type formatting separately to distinguish malformed positions from stale positions.

## Follow-up: persistent mitigation

- Added a `FileType` autocmd in `config/recipe/neovim/lsp.nix` that disables inlay hints for C buffers only.
- Other filetypes keep global inlay hints. clangd diagnostics, completion, and navigation remain enabled in C buffers.
- Alejandra formatting passed.
- A headless Neovim check confirmed that C buffers have hints disabled and Lua buffers keep hints enabled.
- `nix build .#darwinConfigurations.beleap-m1air.system --accept-flake-config --no-link` passed.
- No system activation was performed.
