# Diagnose WezTerm permission relaunch on macOS

- `System Settings` launched WezTerm PID `72331` at 09:48:09 from `/nix/store/cj7x67kkp9ivnn7aabaxvrlk62xjk7b1-wezterm-20261010-073911-e2a98e1b/Applications/WezTerm.app`.
- The Dock points to `/nix/store/nx80a5cy1137an9b536xcp4q6sv2sfi0-wezterm-20261026-072628-e68a8ec2/Applications/WezTerm.app`. The two app bundles share bundle ID `com.github.wez.wezterm` but have different ad-hoc CDHashes (`5138d4be...` and `ce553aed...`).
- `tccd` logged failed code-requirement matches for `kTCCServiceScreenCapture`. Its recorded CDHashes (`53332a16...` and `73d0ea04...`) match neither current app build. This confirms a TCC identity mismatch across WezTerm builds.
- `config/recipe/wezterm/default.nix` configures the Dock with the versioned `stabilizeApp` output and separately installs the Home Manager app identity. No configuration change was made during diagnosis.
- `jj status` was clean before this journal entry. No app was launched or quit during diagnosis.

## Fix

- Changed `config/recipe/wezterm/default.nix` so the Dock points to `/Users/${host.usernameLower}/Applications/Home Manager Apps/WezTerm.app`, the stable Home Manager app path.
- Kept `targets.darwin.appIdentity.apps` enabled. Its stabilized bundle uses the bundle identifier as its designated code requirement.
- Darwin evaluations return the stable app path for `beleap-m1air`, `beleap-macmini`, and `csjang-m3pro`.
- `alejandra --check config/recipe/wezterm/default.nix` and `nix build --no-link .#darwinConfigurations.beleap-m1air.system` passed.
- The Screen Recording TCC entry still needs a one-time reset and approval. I did not reset it or activate the new configuration.
