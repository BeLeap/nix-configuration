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

## 2026-09-06 — Diagnose recurring Ollama EOF

- Confirmed Ollama is healthy: `/api/version`, `/api/tags`, model loading, plain chat, and a minimal native tool call all returned HTTP 200.
- Captured a real ZeroClaw request through a temporary local proxy. ZeroClaw's native `ollama` adapter sent `tools = 0` and a 42,242-character prompt instructing Qwen3.5 to emit XML-like `<tool_call>` markup. The plain version of that large prompt returned HTTP 200; the action version returned HTTP 500 `{"error":"EOF"}`.
- A full-size request with a native `read_skill` tool returned a valid structured tool call. A temporary OpenAI-compatible profile targeting Ollama `/v1` also succeeded end-to-end with the real `pi_delegate` skill and returned its name.
- Root cause: ZeroClaw 0.7.5's Ollama adapter defaults to prompt-guided XML tool calling, while this Qwen3.5/Ollama parser path rejects the generated incomplete XML tool call as `EOF`. `runtime.reasoning_enabled = false` does not remove that incompatibility.
- Recommended mitigation: use `custom:http://127.0.0.1:11434/v1` so ZeroClaw sends native tool definitions. No declarative or live service change was applied during this investigation.
