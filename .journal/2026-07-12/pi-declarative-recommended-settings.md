# Declarative Pi recommended settings

Updated `config/recipe/pi/default.nix` while preserving fully declarative Home Manager management:

- Set default thinking level to `medium`.
- Kept project trust conservative with `defaultProjectTrust = "ask"`.
- Configured Helix (`hx`) as Pi's external editor.
- Disabled Pi install/update telemetry.
- Disabled Pi's startup version check through `PI_SKIP_VERSION_CHECK=1` in the wrapper.

Did not enable long cache retention because it was optional and has provider-specific cost/retention implications. Did not add more packages or mutable settings.

Verification: the file passes the locally installed `alejandra --check`. Full Nix evaluation could not run in the agent sandbox because Nix attempted to fetch the flake registry through blocked network access. `jj diff` was also blocked because the sandbox denied creation of its temporary diff directory.
