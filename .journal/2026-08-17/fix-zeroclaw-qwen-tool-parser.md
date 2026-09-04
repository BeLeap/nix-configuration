# Disable Qwen3.5 reasoning for ZeroClaw

- Added `runtime.reasoning_enabled = false` to the declarative ZeroClaw config rendered by `config/recipe/beleap-macmini/default.nix`.
- This prevents Ollama/Qwen3.5 from entering its default reasoning path that previously produced incomplete tool-call output and HTTP 500 `{"error":"EOF"}` responses.
- Validation passed:
  - `nix-instantiate --parse config/recipe/beleap-macmini/default.nix`
  - Evaluated `darwinConfigurations.beleap-macmini.config.system.build.toplevel.drvPath`
  - Evaluated `darwinConfigurations.beleap-m1air.config.system.build.toplevel.drvPath`
- `alejandra --check` was unavailable in the current shell.
- Applying the configuration still requires the normal Darwin activation on the Mac mini; no live service restart was performed here.

## 2026-09-04 — Disable Discord mention-only mode

- Changed `channels.discord.mention_only` from `true` to `false` in `config/recipe/beleap-macmini/default.nix`, so the bot responds to channel messages without requiring an @mention.
- `alejandra --check` and Darwin configuration evaluation passed. `nh darwin switch` built successfully but could not complete system activation because `sudo` requires an interactive password.
- Activated the newly built launchd plist manually, then verified the generated runtime config contains `mention_only = false`, `zeroclaw config get channels.discord.mention-only` returns `false`, the Discord channel doctor reports healthy, and port `42617` has one listener.
- The source change is durable in Nix; run `sudo nh darwin switch` from `/Users/beleap/nix-configuration` when an interactive password prompt is available so Home Manager owns the currently installed launchd plist again.
