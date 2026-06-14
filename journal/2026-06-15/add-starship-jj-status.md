# Add Starship JJ Status

- Added `custom.jj_status` to `config/recipe/starship/default.nix`.
- The module runs only inside a jj repository via `jj --ignore-working-copy root`.
- It is hidden when `jj diff --summary --ignore-working-copy` reports no changes.
- It reports compact working-copy diff counts from `jj diff --summary --ignore-working-copy`: `M`, `A`, `D`, and `R`.
- Colored `jj_status` counts by state: modified yellow, added green, deleted red, renamed blue.
- Kept `--ignore-working-copy` so prompt rendering does not snapshot the working copy as a side effect.
- Simplified the status `when` check to `test -n "$(jj diff --summary --ignore-working-copy)"` so it does not depend on POSIX-style variable assignment.
- Set jj/git custom modules to `shell = ["sh"]`; Starship invokes it as `sh -c`, while `shell = ["sh" "-c"]` fails because Starship supplies `-c` itself.
- Tightened the other jj custom modules:
  - suppress `jj root` output in `when` checks,
  - hide `jj_bookmark` when the current change has no bookmarks.
