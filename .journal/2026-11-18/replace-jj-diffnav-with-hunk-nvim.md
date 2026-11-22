# Replace jj diffnav with hunk.nvim

- Added `hunk.nvim` and its `nui.nvim` dependency to the Nixvim configuration and initialized the plugin.
- Configured Jujutsu's `hunk` merge tool to open the `HunkDiffView` directory viewer, and changed `jj dfnav` to use it without a pager.
- Set Jujutsu's interactive diff editor to `DiffEditor` so commands that edit partial diffs can use hunk.nvim.
- Kept delta as the formatter for ordinary `jj diff` output.
- Confirmed both plugin package attributes are available in the stable and Darwin nixpkgs sources.
- Parsed both changed Nix files and passed the Alejandra style check; no system build or test suite was run.
- Renamed the Jujutsu viewer shortcut from `dfnav` to `dfui` in a follow-up.
- Follow-up (2026-11-22): Replaced Jujutsu's deprecated `DiffEditor` command with `HunkDiffEditor` in `config/recipe/jujutsu/default.nix`.
- Validation: `nix-instantiate --parse config/recipe/jujutsu/default.nix` and `alejandra --check config/recipe/jujutsu/default.nix` passed.
- Diagnostic (2026-11-22): hunk.nvim calls `:diffthis` before its `on_diff_mount` hook. Neovim disables window-local `wrap` in diff mode unless `diffopt` contains `followwrap`. Confirmed with the installed Neovim. Set `wrap` in `on_diff_mount` for a Hunk-only fix.
- Configuration review (2026-11-22): For preserving wrap in every diff window, append Neovim's built-in `followwrap` to `diffopt` with `vim.opt.diffopt:append("followwrap")`. Confirmed it preserves `wrap` after `:diffthis`. Keep `on_diff_mount` for Hunk-only scope.
- Nixvim support check (2026-11-22): The pinned `opts` module accepts attribute values and emits direct `vim.opt[k] = v` assignments. It has no declarative append operation for `diffopt`. Use `extraConfigLua` with `vim.opt.diffopt:append("followwrap")` to preserve defaults.
- Correction (2026-11-22): Nixvim's `opts.diffopt` accepts raw Lua, so `opts.diffopt = { __raw = "vim.opt.diffopt + 'followwrap'"; };` also appends through Neovim's option object. The equivalent Lua expression passed a local Neovim check.
- GitHub search (2026-11-22): No Nixvim issue specifically requests `opts.diffopt` append syntax. Nixvim issue #502 includes an `extraConfigLua` example using `vim.opt.listchars:append`, but its report concerns a missing plugin module. Neovim issue #39038 covers `diffopt` append semantics and links fix PR #39849.
- Applied (2026-11-23): Added `opts.diffopt.__raw = "vim.opt.diffopt + 'followwrap'"` to `config/recipe/neovim/default.nix`. Nix parsing and Alejandra checks passed. A Neovim test confirmed `:diffthis` leaves `wrap` enabled.
