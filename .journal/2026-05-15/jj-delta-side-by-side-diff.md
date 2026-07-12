# jj delta side-by-side diff investigation

Checked why `jj diff` was not rendering side-by-side.

- `jj 0.40.0` is installed.
- User config is `/Users/beleap/.config/jj/config.toml`.
- Repo config is `/Users/beleap/.config/jj/repos/2955528e109147fcd85b/config.toml`.
- Current relevant config:
  - `ui.diff-formatter = "delta"`
  - `merge-tools.delta.program = "/nix/store/pjy19jmswshasgnvd08nl24p6a4x24zc-delta-0.18.2/bin/delta"`
  - `merge-tools.delta.merge-args = ["-s", "$left", "$output", "--width=$width"]`
- The `-s` side-by-side flag is only in `merge-args`, which `jj diff` does not use.
- `jj diff` uses `ui.diff-formatter` plus `merge-tools.<tool>.diff-args` when invoking an external diff tool.
- Delta can also be used as a pager over git-format diff:
  - `ui.diff-formatter = ":git"`
  - `ui.pager = ["delta", "--side-by-side"]`

Likely fixes:

1. Use delta as a pager over git-format diff.
2. Or keep delta as an external diff tool and add `merge-tools.delta.diff-args = ["--side-by-side", "$left", "$right", "--width=$width"]`.
