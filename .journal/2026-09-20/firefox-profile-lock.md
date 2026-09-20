
- Root cause confirmed in macOS unified logs: the Nix Firefox bundle was denied `file-write-create` for `~/Library/Application Support/Firefox/Profiles/beleap/.parentlock`; the GUI message was misleading. `installs.ini` was not the cause.
- Updated `config/recipe/firefox/default.nix` to set the Firefox wrapper's `appDataDir` and Home Manager `configPath` to `Library/Application Support/org.nixos.firefox`.
- Built the Darwin configuration successfully and ran the generated Home Manager activation as the user. The new launcher contains `MOZ_APP_DATA=/Users/beleap/Library/Application Support/org.nixos.firefox`.
- Explicitly launched `~/Applications/Home Manager Apps/Firefox.app`; the current Nix Firefox process remained alive and created `.parentlock` in the relocated profile, with no sandbox denial.
- `darwin-rebuild switch` is blocked because system activation now requires root and sudo has no cached password. The Dock still points to an older `/nix/store/.../firefox-155.0.1` app, so clicking its old Firefox tile can still reproduce the error.
- Migration destination was created without overwriting existing data. At migration time the old Firefox directory contained only about 2.6 MB; a 2.3 GB `lxajgkoo.dev-edition-default` profile remains untouched in the user's Trash and was not restored because the intended profile was not confirmed.

- Kept the required Nixpkgs macOS data relocation, but refactored the recipe to define `firefoxConfigPath` once and reuse it for `appDataDir` and Home Manager `configPath`; added a short rationale comment.
- Validated the edited Nix module with `nix-instantiate --parse`. No profile data was deleted.
- Updated `config/recipe/macos/default.nix` so the Dock targets `/Users/beleap/Applications/Home Manager Apps/Firefox.app` instead of a versioned Firefox store path; `darwin-rebuild build --flake .#beleap-m1air` succeeded.
- The change is not active in system defaults yet because `darwin-rebuild switch` requires the user's sudo password.
- AeroSpace 0.21.3-Beta omitted Firefox from both `list-apps` and `list-windows --all` even though CoreGraphics reported a visible Firefox window (`PID 87912`, title `Mozilla Firefox`); `aerospace reload-config` did not refresh it. This is currently treated as AeroSpace window-detection state, not a Firefox profile or Dock-path issue.

## Follow-up: AeroSpace validation (2026-09-20)

- Restarted AeroSpace and queried `list-windows --all`; it returned no windows, not only Firefox.
- Verified the macOS session is screen-locked: `CGSessionScreenIsLocked=1`, frontmost app is `com.apple.loginwindow` (PID 428). This explains the malformed AX objects and `_AXUIElementGetWindow` failures; AeroSpace cannot enumerate/manage windows while the session is locked.
- CoreGraphics still reports Firefox's four on-screen windows while locked, so that observation does not prove Firefox is the cause.
- `sudo darwin-rebuild switch --flake .#beleap-m1air` remains blocked because the harness has no interactive sudo password. A non-root `darwin-rebuild build` succeeds.
- No repository source changes were made during this validation; Calculator opened for a control test was closed afterward.
- After the user unlocked macOS, `aerospace list-windows --all` correctly listed Firefox window `1238` with PID `7080` and bundle ID `org.nixos.firefox`. The AeroSpace/Firefox detection issue was therefore a locked-session observation, not a remaining Firefox accessibility failure.

## Follow-up: replace the Darwin shell-wrapper patch (2026-09-20)

- Replaced the `overrideAttrs`/`plistlib` workaround in `config/recipe/firefox/default.nix` with nixpkgs' existing `wrapFirefox` builder configured as `makeWrapper = pkgs.makeBinaryWrapper`.
- Kept both the relocated `appDataDir` and Home Manager `configPath`; the binary wrapper embeds the same runtime environment without modifying `Info.plist`.
- `nix-instantiate --parse`, Alejandra, Statix, and `darwin-rebuild build --flake .#beleap-m1air` passed.
- The generated app's `Contents/MacOS/firefox` and `.firefox-old` are Mach-O arm64 executables, no shell `firefox-wrapper` exists, and the wrapper contains `MOZ_APP_DATA`, `MOZ_APP_LAUNCHER`, `MOZ_SYSTEM_DIR`, and `LD_LIBRARY_PATH`.
- Ran the generated Home Manager activation successfully. The user launcher now points to the binary-wrapper package; the running Firefox process was not restarted, so runtime validation of the new bundle remains pending.
- No profile data was deleted. System activation still requires an interactive sudo password.
- `nix flake check --no-build --show-trace` passed; existing Home Manager legacy-default warnings remain unchanged.

## Follow-up: AeroSpace omitted Firefox again (2026-09-20)

- Firefox was running from the new binary-wrapper package at `/nix/store/2baj0zvb79w455dyc3asqa803sl2lsi4-firefox-155.0.1`, with bundle ID `org.nixos.firefox`.
- AeroSpace omitted Firefox from `list-apps`; the frontmost process was `loginwindow` (PID 428), strongly indicating the macOS session was locked again.
- Unlocking the session is the next discriminating test. If Firefox remains absent afterward, investigate whether the binary wrapper's `.firefox-old` process path still confuses AeroSpace before changing the wrapper design.

## Follow-up: binary wrapper rejected (2026-09-20)

- After the user reported unlocking, CoreGraphics still saw two Firefox windows, but AeroSpace omitted Firefox from `list-apps` and `list-windows --all`; restarting AeroSpace's LaunchAgent did not change this.
- `lsappinfo` reported bundle ID `org.nixos.firefox` but executable path `Contents/MacOS/.firefox-old`, confirming the binary wrapper does not satisfy AeroSpace's process-path requirement.
- Replaced the binary-wrapper approach with the proven Darwin arrangement: move the real Mach-O executable back to `Contents/MacOS/firefox` and inject the wrapper environment into `Info.plist` with `/usr/bin/plutil` at build time. Kept the binary-wrapper approach only out of the final configuration; no profile data was changed.
- Alejandra, Statix, Nix parsing, and `darwin-rebuild build --flake .#beleap-m1air` passed. The generated app has a Mach-O `firefox`, a renamed inactive shell wrapper, and the required `LSEnvironment` values.
- Ran the generated Home Manager activation successfully. The currently running Firefox process is still the old binary-wrapper process and must be restarted before validating AeroSpace again.

## Follow-up: Dock still launched the old package (2026-09-20)

- After the user restarted Firefox from the Dock, the parent process was still `/nix/store/2baj0zvb79w455dyc3asqa803sl2lsi4-firefox-155.0.1/.../Contents/MacOS/.firefox-old`.
- The Dock tile points to `/nix/store/qdzdr9r4h8ncbqcris46k04ghx4djqvh-home-manager-applications/Applications/Firefox.app`, which symlinks to that old binary-wrapper package; it does not yet point to `/Users/beleap/Applications/Home Manager Apps/Firefox.app`.
- The declarative Dock path is already in `config/recipe/macos/default.nix`, but `darwin-rebuild switch` has not run because interactive sudo is required. The pending system activation is the next fix; no profile data was changed.
