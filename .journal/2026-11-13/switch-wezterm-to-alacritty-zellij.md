# Replace WezTerm with Alacritty and Zellij

## Changes

- Replaced the WezTerm recipe with separate Alacritty and Zellij recipes.
- Alacritty starts or attaches to the `sp` Zellij session.
- Zellij clears its default keybindings and starts in locked mode.
- `Ctrl-a` enters a custom tmux-style mode.
- Ported `wts`, `wzs`, and `wzsf` from WezTerm workspaces to Zellij sessions.
- Updated `jws` and Pi notification titles to use `ZELLIJ_SESSION_NAME`.
- Zellij converts host OSC notifications to BEL. Alacritty runs `osascript` on macOS and `notify-send` on Linux.

## Validation

- Darwin system evaluation passed for `beleap-m1air`.
- The Alacritty package and `beleap-utils` package builds passed.
- Zellij `setup --check` accepted the generated configuration.
- Python `tomllib` parsed the generated Alacritty configuration.
- `bash -n`, ShellCheck, Alejandra, and Statix checks passed for changed files.
- Mocked and live Zellij tests passed for `wts` session creation and switching.

## Limitations

- Bell conversion drops the OSC title and message. Alacritty shows a fixed notification message.
- I did not test a real macOS notification banner or notification permission.
- I stopped the full Darwin system build after Nix planned 762.3 MiB of downloads and 6.2 GiB of unpacked dependencies.
- NixOS evaluation remains blocked by the existing `utm-5.0.8` package, which does not support `aarch64-linux`.

## Follow-up: switch from Alacritty to Rio

- Replaced the Alacritty recipe with Rio `0.5.28` from `pkgs.unstable.rio`.
- Configured `navigation.mode = "Plain"` to disable Rio's tab key bindings.
- Kept the `sp` Zellij startup and Gruvbox colors with the Hanadia Mono font.
- Set Zellij's host notification protocol to OSC 9. Rio documents OSC 9 and OSC 777 support.
- Rio issue #1831 reports that macOS may file foreground notifications in Notification Center without showing banners. PR #1832, which proposes a foreground presentation fix, remains open.
- Built the Rio package and verified `Rio.app` uses bundle identifier `com.raphaelamorim.rio`.
- The Darwin system was not applied.

## Rio validation

- Darwin system evaluation passed for `beleap-m1air`.
- The generated Rio TOML parsed successfully with Python's `tomllib`.
- Zellij `setup --check` accepted the generated configuration with `host_notification_protocol "osc9"`.
- Alejandra and Statix passed for the changed Nix files.
- NixOS system evaluation remains blocked by the existing `utm-5.0.8` package, which does not support `aarch64-linux`.
- I did not test a live macOS notification banner.
- Mapped Alacritty's 8px horizontal and 0px vertical padding to Rio panel padding `[0, 8]`.

## Rio app identity build fix

- Nixpkgs Rio ships `Contents/MacOS/rio` as a symlink. `stabilizeApp` rejects that symlink because it is not a Mach-O file.
- Added `mkDarwinRio` to copy the Mach-O executable into the app bundle before identity stabilization.
- Built the stabilized Rio app and verified its code signature with designated identifier `com.raphaelamorim.rio`.
- `nix build .#darwinConfigurations.beleap-m1air.system --accept-flake-config` passed.
- The Darwin system remains unapplied.

## Disable Zellij session recovery

- Set `session_serialization false` in `config/recipe/zellij/config.kdl` to disable session serialization and resurrection.
- Zellij 0.45.1 `setup --check` accepted the generated configuration.
