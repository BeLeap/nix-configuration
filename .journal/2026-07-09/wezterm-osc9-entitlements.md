# WezTerm OSC 9 notifications blocked by entitlements

- OSC 9 test (`printf '\033]9;%s\033\\' 'OpenCode OSC 9 WezTerm test'`) was emitted from opencode under WezTerm; no notification appeared.
- WezTerm version: `0-unstable-2026-03-31` (nixpkgs build, `config/recipe/wezterm/default.nix`).
- WezTerm docs confirm OSC 9 is supported for toast notifications, gated by `notification_handling` (default suppresses the focused pane). The config was missing the option; added `config.notification_handling = 'AlwaysShow'` in `config/recipe/wezterm/wezterm.lua` and applied via `nh darwin switch`.
- After applying, the active `~/.config/wezterm/wezterm.lua` (Nix store) contains the option. WezTerm reloads config automatically.
- macOS unified log (`log show`) confirms WezTerm IS receiving the OSC and calling `UNUserNotificationCenter.addRequest`:
  - `[com.github.wez.wezterm] Adding notification request <id> to destinations: Default`
  - but `usernotificationsd` rejects: `Entitlement 'com.apple.private.usernotifications.bundle-identifiers' required to request user notifications`
  - and `addRequest not allowed: com.github.wez.wezterm` / `Added notification request: [ hasError: 1 ... ]`
- Root cause: the nixpkgs-built `WezTerm.app` is rebuilt from source and does not carry the private `com.apple.private.usernotifications.bundle-identifiers` entitlement that macOS requires to post User Notifications. This is a code-signing/entitlement limitation of the Nix build, not a config issue.
- Contrast: the previously trialed official Ghostty build posted notifications successfully (prior journal `try-zellij.md` noted `com.apple.UserNotifications` "Adding notification request" entries with no error under Ghostty direct, no multiplexer).
- The config change is still worth keeping (`notification_handling = 'AlwaysShow'`) so that once a properly entitled WezTerm build runs, OSC 9 notifications will show even from the focused pane.
- Follow-up options: (1) use an officially signed/notarized WezTerm build outside Nix for GUI notifications, (2) keep notifications flowing through an external notifier (e.g. `terminal-notifier` / `osascript`) driven by opencode's attention hooks instead of OSC 9, or (3) track nixpkgs/wezterm for a fix that signs the app with the notification entitlement.
