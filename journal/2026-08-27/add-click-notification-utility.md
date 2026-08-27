# Add click-notification utility

Added `click-notification` to `beleap-utils`. The command uses `ax` to locate
the uppermost visible macOS Notification Center notification and click its
leading edge. After the first click, it checks Notification Center again and
clicks the top item a second time if the first click expanded a grouped
notification. It exits unsuccessfully when no visible notification is found.

Bound Aerospace's `cmd-n` shortcut to run `click-notification` with
`exec-and-forget`, making the utility available without opening a terminal.

Updated the binding to use the utility's absolute Nix store path from
`pkgs.beleap-utils`, so AeroSpace does not depend on its launch environment's
`PATH` to find `click-notification`.
