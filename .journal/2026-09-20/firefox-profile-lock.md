
- Root cause confirmed in macOS unified logs: the Nix Firefox bundle was denied `file-write-create` for `~/Library/Application Support/Firefox/Profiles/beleap/.parentlock`; the GUI message was misleading. `installs.ini` was not the cause.
- Updated `config/recipe/firefox/default.nix` to set the Firefox wrapper's `appDataDir` and Home Manager `configPath` to `Library/Application Support/org.nixos.firefox`.
- Built the Darwin configuration successfully and ran the generated Home Manager activation as the user. The new launcher contains `MOZ_APP_DATA=/Users/beleap/Library/Application Support/org.nixos.firefox`.
- Explicitly launched `~/Applications/Home Manager Apps/Firefox.app`; the current Nix Firefox process remained alive and created `.parentlock` in the relocated profile, with no sandbox denial.
- `darwin-rebuild switch` is blocked because system activation now requires root and sudo has no cached password. The Dock still points to an older `/nix/store/.../firefox-155.0.1` app, so clicking its old Firefox tile can still reproduce the error.
- Migration destination was created without overwriting existing data. At migration time the old Firefox directory contained only about 2.6 MB; a 2.3 GB `lxajgkoo.dev-edition-default` profile remains untouched in the user's Trash and was not restored because the intended profile was not confirmed.

- Kept the required Nixpkgs macOS data relocation, but refactored the recipe to define `firefoxConfigPath` once and reuse it for `appDataDir` and Home Manager `configPath`; added a short rationale comment.
- Validated the edited Nix module with `nix-instantiate --parse`. No profile data was deleted.
