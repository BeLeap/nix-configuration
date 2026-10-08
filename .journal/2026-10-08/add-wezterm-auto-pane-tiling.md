# Add WezTerm automatic pane tiling

- Bound `Ctrl+n` to spawn a pane by splitting the active pane along its wider axis. The direction is chosen from the pane's dimensions, accounting for terminal cells being taller than they are wide.
- Kept the existing leader split shortcuts available.
- Did not run configuration checks or tests.
- Follow-up: changed `Ctrl+n` to always split right, keeping the current pane on the left and placing the new pane on the right half.
- Correction: the adaptive direction described above was an initial implementation and is not the final behavior.
- Follow-up: `Ctrl+n` now alternates split direction per tab, starting top/bottom and then left/right.
- Added `Ctrl+r` to rotate the active tab's pane layout clockwise.
- Removed the added `Ctrl+n` binding and its callback at the user's request because they already have a Ctrl+N keymap.
- Restored `Ctrl+n` at the user's request; it alternates top/bottom and left/right splits per tab. `Ctrl+r` remains bound to clockwise rotation.
- Changed pane split and clockwise rotation bindings to `LEADER+n` and `LEADER+r`. Moved next-tab navigation from `LEADER+n` to `LEADER+Shift+n` to avoid a duplicate key assignment.
- Removed relative next/previous tab navigation at the user's request; numbered tab shortcuts remain.
- Replaced alternating splits with the requested ㅑ layout: first split right to keep the main pane on the left, then split the rightmost tallest pane top/bottom.
