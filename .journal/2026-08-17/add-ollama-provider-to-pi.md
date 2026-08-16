# Add the Mac mini Ollama provider to Pi

- Added a declarative Pi `models.json` provider named `ollama` at `http://beleap-macmini:11434/v1`.
- Registered `qwen3.5:9b` with zero cost metadata, an 8K context limit, image input support, and Ollama/OpenAI compatibility overrides.
- Added `ollama/qwen3.5:9b` to Pi's enabled model cycle without changing the default cloud provider.
- Changed the Mac mini Ollama listener from loopback to `0.0.0.0:11434` so the provider can be reached over Tailscale using MagicDNS name `beleap-macmini`.

Validation:

- Parsed both modified Nix recipes with `nix-instantiate --parse`.
- Evaluated generated `models.json` as valid JSON and confirmed the provider URL/model metadata.
- Evaluated both affected Darwin systems: `beleap-m1air` and `beleap-macmini`.
