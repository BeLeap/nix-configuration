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
