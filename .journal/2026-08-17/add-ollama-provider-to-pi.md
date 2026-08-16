# Add the Mac mini Ollama provider to Pi

- Added a declarative Pi `models.json` provider named `ollama` at `http://beleap-macmini:11434/v1`.
- Registered `qwen3.5:9b` with zero cost metadata, an 8K context limit, image input support, and Ollama/OpenAI compatibility overrides.
- Added `ollama/qwen3.5:9b` to Pi's enabled model cycle without changing the default cloud provider.
- Changed the Mac mini Ollama listener from loopback to `0.0.0.0:11434` so the provider can be reached over Tailscale using MagicDNS name `beleap-macmini`.

Validation:

- Parsed both modified Nix recipes with `nix-instantiate --parse`.
- Evaluated generated `models.json` as valid JSON and confirmed the provider URL/model metadata.
- Evaluated both affected Darwin systems: `beleap-m1air` and `beleap-macmini`.

Follow-up:

- Ollama defaults Qwen3.5 to thinking, which consumed the configured output budget before emitting an answer through Pi and produced `The response was truncated before completion.`.
- Added `samplingParams.reasoning_effort = "none"` to the Pi model definition. Direct API testing completed successfully with this setting.

Additional finding:

- Pi's repository/tool prompt used 4,375 input tokens while requesting up to 4,096 output tokens against an 8K context, and Ollama returned `finish_reason = length` after one output token.
- Increased the Ollama and Pi model context settings to 16K while retaining a 4K output limit.

Correction:

- Kept the server and Pi context at 8K to reduce memory use, and lowered Pi's maximum output to 3,072 tokens so the 4,375-token Pi prompt fits without exhausting the context.

Model adjustment:

- Switched the Pi provider to `qwen3.5:4b` and increased the server/Pi context to 32K, retaining a 4K output limit.
- The Mac mini needs the new model pulled explicitly after applying the configuration: `ollama pull qwen3.5:4b`.
