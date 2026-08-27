# Add click-notification utility

Added `click-notification` to `beleap-utils`. The command uses `ax` to locate
the uppermost visible macOS Notification Center notification and click its
leading edge. After the first click, it checks Notification Center again and
clicks the top item a second time if the first click expanded a grouped
notification. It exits unsuccessfully when no visible notification is found.
