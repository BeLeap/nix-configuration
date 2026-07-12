Investigated `activationScripts.setWallpaper` in `config/recipe/macos/default.nix`.

Findings:
- The script uses `osascript` with `System Events` to set desktop pictures.
- In `nix-darwin`, activation scripts run during `darwin-rebuild switch` in system activation context, typically as `root`, not as the logged-in GUI user.
- Changing wallpaper through `System Events` is tied to the active user desktop session and can fail or no-op when invoked from system activation.
- The Nix path interpolation for `../../../files/apple-colors-small-4k.png` is not the primary issue; the execution context is.

Recommended direction:
- Move wallpaper application to a per-user `launchd` agent via Home Manager, or invoke the script with `launchctl asuser` targeting the primary user session.

Applied change:
- Removed the `system.activationScripts.setWallpaper` hook.
- Added a Home Manager `launchd.agents.set-wallpaper` LaunchAgent with `RunAtLoad = true`.
- The agent runs `/usr/bin/osascript` in the logged-in user session and passes the wallpaper path as a `POSIX file`.
